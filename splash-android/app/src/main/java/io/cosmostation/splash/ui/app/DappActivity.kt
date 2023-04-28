package io.cosmostation.splash.ui.app

import android.content.DialogInterface
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.webkit.*
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.google.gson.Gson
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.api.SuiUtilService
import io.cosmostation.splash.databinding.ActivityDappBinding
import io.cosmostation.splash.model.network.TransactionBlock
import io.cosmostation.splash.ui.common.LoadingFragment
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.SuiTransactionBlockResponseOptions
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import net.i2p.crypto.eddsa.Utils
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.BufferedReader
import java.util.*


class DappActivity : AppCompatActivity() {

    private lateinit var binding: ActivityDappBinding

    var dialog: LoadingFragment = LoadingFragment()

    override fun onBackPressed() {
        if (binding.webview.canGoBack()) {
            binding.webview.goBack()
        } else {
            super.onBackPressed()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityDappBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.dappClose.setOnClickListener { finish() }
        binding.url.text = Uri.parse(intent.getStringExtra("url")).host
        WebView.setWebContentsDebuggingEnabled(true)
        binding.webview.settings.apply {
            javaScriptEnabled = true
            domStorageEnabled = true
            mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
        }
        binding.webview.webViewClient = object : WebViewClient() {
            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
                binding.url.text = Uri.parse(url).host
                try {
                    val inputStream = assets.open("injectScript.js")
                    inputStream.bufferedReader().use(BufferedReader::readText)
                } catch (e: Exception) {
                    null
                }?.let { view?.loadUrl("javascript:(function(){$it})()") }
            }
        }
        binding.webview.addJavascriptInterface(DappJavascriptInterface(), "station")
        binding.webview.webChromeClient = object : WebChromeClient() {
            override fun onJsAlert(
                view: WebView, url: String, message: String, result: JsResult
            ): Boolean {
                AlertDialog.Builder(
                    view.context
                ).setMessage(message).setPositiveButton("OK") { dialog: DialogInterface?, which: Int -> result.confirm() }.setOnDismissListener { dialog: DialogInterface? -> result.confirm() }.create().show()
                return true
            }

            override fun onJsConfirm(
                view: WebView, url: String, message: String, result: JsResult
            ): Boolean {
                AlertDialog.Builder(
                    view.context
                ).setMessage(message).setPositiveButton("OK") { _: DialogInterface?, _: Int -> result.confirm() }.setNegativeButton("Cancel") { _: DialogInterface?, _: Int -> result.cancel() }.setOnDismissListener { dialog: DialogInterface? -> result.cancel() }.create().show()
                return true
            }
        }
        intent.getStringExtra("url")?.let { binding.webview.loadUrl(it) }
    }

    fun processRequest(request: String) {
        var isSplash = false
        try {
            val requestJson = JSONObject(request)
            if (!requestJson.has("isSplash") || !requestJson.getBoolean("isSplash")) {
                return
            }
            isSplash = true
            val messageId = requestJson.getLong("messageId")
            val messageJson = requestJson.getJSONObject("message")
            when (messageJson.getString("method")) {
                "get-account-request" -> {
                    SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.let {
                        val keyPair = SuiClient.instance.getKeyPair(it.mnemonic)
                        val pubKey = keyPair.publicKey.abyte
                        val dataJson = JSONObject()
                        dataJson.put("address", it.address)
                        dataJson.put("publicKey", Utils.bytesToHex(pubKey))
                        appToWebResult(messageJson, dataJson, messageId)
                    }
                }
                "execute-transaction-request" -> {
                    val params = messageJson.getJSONObject("params")
                    signAfterAction("sui:signAndExecuteTransactionBlock", messageId, params) {
                        val txBytes = Utils.hexToBytes(it)
                        val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                        val mnemonic = SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.mnemonic
                        val keyPair = SuiClient.instance.getKeyPair(mnemonic)
                        val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                        CoroutineScope(Dispatchers.IO).launch {
                            val executeResult = SuiClient.instance.executeTransaction(
                                txBytes, signedTxBytes, keyPair, SuiTransactionBlockResponseOptions(showInput = true, showEffects = true, showEvents = true)
                            )
                            val resultJson = JSONObject(Gson().toJson(executeResult))
                            appToWebResult(messageJson, resultJson, messageId)
                        }
                    }
                }
                "sign-transaction-request" -> {
                    val params = messageJson.getJSONObject("params")
                    signAfterAction("sui:signTransactionBlock", messageId, params) {
                        val txBytes = Utils.hexToBytes(it)
                        val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                        val mnemonic = SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.mnemonic
                        mnemonic?.let {
                            val keyPair = SuiClient.instance.getKeyPair(it)
                            val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                            val transactionBlockBytes = Base64.getEncoder().encodeToString(txBytes)
                            val signature = Base64.getEncoder().encodeToString(byteArrayOf(0x00) + signedTxBytes + keyPair.publicKey.abyte)
                            val dataJson = JSONObject()
                            dataJson.put("signature", signature)
                            dataJson.put("transactionBlockBytes", transactionBlockBytes)
                            appToWebResult(messageJson, dataJson, messageId)
                        } ?: run {
                            appToWebError("Sign error", messageId)
                        }
                    }
                }
                else -> {
                    appToWebError("Unsupported request", messageId)
                }
            }
        } catch (e: Exception) {
            if (isSplash) {
                appToWebError(e.message, 0L)
            }
        }
    }

    private fun signAfterAction(title: String, messageId: Long, params: JSONObject, action: (hexTxBytes: String) -> Unit) {
        SignDialog(title, params, object : SignDialog.SignListener {
            override fun confirm() {
                dialog.show(supportFragmentManager, LoadingFragment::class.java.name)
                SuiUtilService.create().buildSuiTransactionBlock(TransactionBlock(params.getString("data"), params.getString("account"), SuiClient.instance.currentNetwork.rpcUrl)).enqueue(object : Callback<String> {
                    override fun onResponse(call: Call<String>, response: Response<String>) {
                        response.body()?.let {
                            action(it)
                        } ?: run {
                            appToWebError("TransactionBlock build error", messageId)
                        }
                    }

                    override fun onFailure(call: Call<String>, t: Throwable) {
                        appToWebError("TransactionBlock build error", messageId)
                    }
                })
            }

            override fun cancel() {
                appToWebError("Cancel", messageId)
            }

        }).show(supportFragmentManager, SignDialog::class.java.name)
    }

    private fun appToWebError(error: String?, messageId: Long) {
        val responseJson = JSONObject()
        responseJson.put("error", error)
        val postMessageJson = JSONObject()
        postMessageJson.put("response", responseJson)
        postMessageJson.put("isSplash", true)
        postMessageJson.put("messageId", messageId)
        runOnUiThread {
            binding.webview.evaluateJavascript(String.format("window.postMessage(%s);", postMessageJson.toString()), null)
            dialog.dismiss()
        }
    }

    private fun appToWebResult(messageJson: JSONObject, resultJson: JSONObject, messageId: Long) {
        val responseJson = JSONObject()
        responseJson.put("result", resultJson)
        val postMessageJson = JSONObject()
        postMessageJson.put("message", messageJson)
        postMessageJson.put("response", responseJson)
        postMessageJson.put("messageId", messageId)
        postMessageJson.put("isSplash", true)
        runOnUiThread {
            binding.webview.evaluateJavascript(String.format("window.postMessage(%s);", postMessageJson.toString()), null)
            dialog.dismiss()
        }
    }

    inner class DappJavascriptInterface {
        @JavascriptInterface
        fun request(message: String) {
            processRequest(message)
        }
    }
}
