package io.cosmostation.splash.ui.app

import android.content.DialogInterface
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.MenuItem
import android.view.View
import android.webkit.*
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.walletconnect.android.Core
import com.walletconnect.android.CoreClient
import com.walletconnect.sign.client.Sign
import com.walletconnect.sign.client.SignClient
import com.walletconnect.sign.client.SignInterface
import io.cosmostation.splash.BuildConfig
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.ActivityWalletConnectBinding
import io.cosmostation.splash.model.ConnectType
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.JsonRpcRequest
import io.cosmostation.suikotlin.model.SuiTransactionBlockResponseOptions
import io.cosmostation.suikotlin.model.SuiWrappedTxBytes
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.apache.commons.lang3.StringUtils
import org.json.JSONObject
import java.io.BufferedReader
import java.util.*

class WalletConnectActivity : AppCompatActivity() {


    private lateinit var binding: ActivityWalletConnectBinding

    private var mWalletConnectURI: String? = null

    private var connectType = ConnectType.QRWalletConnect

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWalletConnectBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        processByConnectType()
    }

    private fun processByConnectType() {
        loadConnectType()
        fillByConnectType()
        changeDappConnectStatus(false)
    }

    private fun fillByConnectType() {
        intent.data?.let { data ->
            if (ConnectType.DeepLinkWalletConnectCommon == connectType) {
                setupWalletConnectTypeView(data.toString().replace("wc:/", "wc:"))
            } else {
                data.query?.let { query ->
                    if (connectType.isDapp()) {
                        setupDappTypeView(query)
                    } else {
                        setupWalletConnectTypeView(query)
                    }
                }
            }
        }
        intent.extras?.getString(INTENT_WC_URL_KEY)?.let {
            setupWalletConnectTypeView(it)
        }
    }

    private fun loadConnectType() {
        intent.data?.let { data ->
            if (fromCosmostationScheme(data)) {
                when (data.host) {
                    WC_URL_SCHEME_HOST_WC -> {
                        connectType = ConnectType.DeepLinkWalletConnect
                    }
                    WC_URL_SCHEME_HOST_DAPP_EXTERNAL -> {
                        connectType = ConnectType.ExternalDapp
                    }
                    WC_URL_SCHEME_HOST_DAPP_INTERNAL -> {
                        connectType = ConnectType.InternalDapp
                    }
                    else -> {}
                }
            } else if (fromCommonWalletConnectScheme(data)) {
                connectType = ConnectType.DeepLinkWalletConnectCommon
            }
        }
    }

    private fun setupDappTypeView(url: String) {
        supportActionBar?.setDisplayHomeAsUpEnabled(false)
        binding.toolbarTitle.visibility = View.GONE
        binding.dappLayout.visibility = View.VISIBLE
        binding.wcPeer.text = url
        binding.dappWebView.visibility = View.VISIBLE
        binding.wcLayer.visibility = View.GONE
        binding.loadingLayer.visibility = View.GONE
        binding.btnDisconnect.visibility = View.GONE
        binding.dappWebView.loadUrl(url)
        WebStorage.getInstance().deleteAllData()
    }

    private fun changeDappConnectStatus(connected: Boolean) {
        if (connected) {
            binding.wcLight.setImageResource(R.drawable.ic_passed_img)
            binding.wcState.text = "Connected"
            binding.wcState.setTextColor(getColor(R.color.color_mode_base05))
        } else {
            binding.wcLight.setImageResource(R.drawable.ic_pass_gr)
            binding.wcState.text = "Not Connected"
            binding.wcState.setTextColor(getColor(R.color.color_mode_base04))
        }
    }

    private fun setupWalletConnectTypeView(url: String) {
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        binding.toolbarTitle.visibility = View.VISIBLE
        binding.dappLayout.visibility = View.GONE
        binding.dappWebView.visibility = View.GONE
        binding.btnDisconnect.visibility = View.VISIBLE
        mWalletConnectURI = url
        connectWalletConnect()
    }

    private fun processConnectScheme(url: String) {
        if (isSessionConnected()) return
        binding.loadingLayer.visibility = View.VISIBLE
        mWalletConnectURI = url
        connectWalletConnect()
    }

    private fun fromCosmostationScheme(data: Uri): Boolean {
        return WC_URL_SCHEME_COSMOSTATION == data.scheme
    }

    private fun fromCommonWalletConnectScheme(data: Uri): Boolean {
        return WC_URL_SCHEME_COMMON == data.scheme
    }

    private fun setupViews() {
        binding.dappClose.setOnClickListener { finish() }
        binding.btnDisconnect.setOnClickListener {
            moveToBackIfNeed()
            finish()
        }
        binding.dappWebView.apply {
            settings.apply {
                javaScriptEnabled = true
                userAgentString = "$userAgentString Sui/APP/Android/${BuildConfig.VERSION_NAME}"
                domStorageEnabled = true
                mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
                webChromeClient = dappWebChromeClient
                webViewClient = dappWebViewClient
            }
        }
        setSupportActionBar(binding.toolBar)
        supportActionBar?.setDisplayShowTitleEnabled(false)
    }

    private fun connectWalletConnect(uri: String) {
        val pairingParams = Core.Params.Pair(uri)
        CoreClient.Pairing.pair(pairingParams) {}

        SignClient.setWalletDelegate(object : SignInterface.WalletDelegate {
            override fun onConnectionStateChange(state: Sign.Model.ConnectionState) {
            }

            override fun onError(error: Sign.Model.Error) {
            }

            override fun onSessionDelete(deletedSession: Sign.Model.DeletedSession) {
            }

            override fun onSessionProposal(sessionProposal: Sign.Model.SessionProposal) {
                if (isFinishing) {
                    return
                }

                val sessionNamespaces: MutableMap<String, Sign.Model.Namespace.Session> = mutableMapOf()
                val methods = sessionProposal.requiredNamespaces.values.flatMap { it.methods }
                val events = sessionProposal.requiredNamespaces.values.flatMap { it.events }
                runOnUiThread {
                    val chains = sessionProposal.requiredNamespaces.values.flatMap { it.chains }
                    chains.map { chain ->
                        val chainName = chain.split(":")[0]
                        val address = SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address
                        sessionNamespaces[chainName] = Sign.Model.Namespace.Session(
                            accounts = listOf("$chain:$address"), methods = methods, events = events, extensions = null
                        )
                    }
                    val approveProposal = Sign.Params.Approve(
                        proposerPublicKey = sessionProposal.proposerPublicKey, namespaces = sessionNamespaces
                    )

                    binding.loadingLayer.apply {
                        postDelayed({ visibility = View.GONE }, 2500)
                    }
                    if (!connectType.isDapp()) {
                        setupConnectInfoView(sessionProposal)
                    }
                    changeDappConnectStatus(true)
                    SignClient.approveSession(approveProposal) {}
                }
            }

            override fun onSessionRequest(sessionRequest: Sign.Model.SessionRequest) {
                if (isFinishing) {
                    return
                }

                processSessionRequest(sessionRequest)
            }

            override fun onSessionSettleResponse(settleSessionResponse: Sign.Model.SettledSessionResponse) {
            }

            override fun onSessionUpdateResponse(sessionUpdateResponse: Sign.Model.SessionUpdateResponse) {
            }
        })
    }

    private fun setupConnectInfoView(proposal: Sign.Model.SessionProposal) {
        if (connectType.isDapp()) {
            return
        }

        val address = SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address
        binding.wcAddress.text = address

        if (proposal.icons.isNotEmpty()) {
            binding.wcImg.setImageURI(proposal.icons.first().path)
        } else {
            binding.wcImg.setImageResource(R.drawable.logo)
        }
        if (StringUtils.isBlank(proposal.name)) {
            binding.wcName.text = "WalletConnect"
        } else {
            binding.wcName.text = proposal.name
        }
        binding.wcUrl.text = proposal.url
        binding.wcLayer.visibility = View.VISIBLE
        binding.loadingLayer.visibility = View.GONE
    }

    private fun processSessionRequest(sessionRequest: Sign.Model.SessionRequest) {
        runOnUiThread {
            sessionRequest.request.apply {
                when (method) {
                    "sui_getAccount" -> {
                        approveGetAccountRequest(sessionRequest)
                    }
                    "sui_executeMoveCall" -> {
                        val gson = GsonBuilder().setPrettyPrinting().create()
                        val message = gson.toJson(gson.fromJson(params, Any::class.java))
                        SignDialog(method, JSONObject(message), object : SignDialog.SignListener {
                            override fun confirm() {
                                approveExecuteRequest(method, sessionRequest)
                            }

                            override fun cancel() {
                                val response = Sign.Params.Response(
                                    sessionTopic = sessionRequest.topic, jsonRpcResponse = Sign.Model.JsonRpcResponse.JsonRpcError(
                                        sessionRequest.request.id, 500, "Cancel request."
                                    )
                                )
                                SignClient.respond(response) { }
                            }

                        }).show(supportFragmentManager, SignDialog::class.java.name)
                    }
                }
            }
        }
    }

    private fun approveExecuteRequest(method: String, sessionRequest: Sign.Model.SessionRequest) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val list = Gson().fromJson(sessionRequest.request.params, List::class.java)
                val temp = list[0] as? Map<String, Any>
                temp?.let {
                    val params = listOf(
                        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address, temp["packageObjectId"], temp["module"], temp["function"], temp["typeArguments"], temp["arguments"], temp["gasPayment"], (temp["gasBudget"] as Double).toInt()
                    )
                    val tempResult = SuiClient.instance.fetchCustomRequest(
                        JsonRpcRequest(
                            "sui_moveCall", params
                        )
                    )
                    val transferTxBytes = Gson().fromJson(
                        Gson().toJson(tempResult!!.result), SuiWrappedTxBytes::class.java
                    )
                    val txBytes = Base64.getDecoder().decode(transferTxBytes.txBytes)
                    val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                    val keyPair = SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.mnemonic?.let {
                        SuiClient.instance.getKeyPair(it)
                    } ?: SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.privateKey?.let {
                        SuiClient.instance.getKeyPairByPrivateKey(it)
                    }

                    keyPair?.let {
                        val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                        val executeResult = SuiClient.instance.executeTransaction(
                            txBytes, signedTxBytes, keyPair, SuiTransactionBlockResponseOptions(showInput = true, showEffects = true)
                        )
                        val response = Sign.Params.Response(
                            sessionTopic = sessionRequest.topic, jsonRpcResponse = Sign.Model.JsonRpcResponse.JsonRpcResult(
                                sessionRequest.request.id, Gson().toJson(executeResult)
                            )
                        )
                        SignClient.respond(response) {}
                    }
                } ?: run {
                    throw Exception()
                }
            } catch (e: Exception) {
                val response = Sign.Params.Response(
                    sessionTopic = sessionRequest.topic, jsonRpcResponse = Sign.Model.JsonRpcResponse.JsonRpcError(
                        sessionRequest.request.id, 500, "Signing error."
                    )
                )
                SignClient.respond(response) { }
            }
            moveToBackIfNeed()
        }
    }

    private fun approveGetAccountRequest(sessionRequest: Sign.Model.SessionRequest) {
        try {
            val address = SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address
            val response = Sign.Params.Response(
                sessionTopic = sessionRequest.topic, jsonRpcResponse = Sign.Model.JsonRpcResponse.JsonRpcResult(
                    sessionRequest.request.id, address
                )
            )
            SignClient.respond(response) {}
            Toast.makeText(
                baseContext, "Okok", Toast.LENGTH_SHORT
            ).show()
        } catch (e: Exception) {
            val response = Sign.Params.Response(
                sessionTopic = sessionRequest.topic, jsonRpcResponse = Sign.Model.JsonRpcResponse.JsonRpcError(
                    sessionRequest.request.id, 500, "Signing error."
                )
            )
            SignClient.respond(response) { }
            Toast.makeText(
                baseContext, "Error", Toast.LENGTH_SHORT
            ).show()
        }
        moveToBackIfNeed()
    }


    private fun connectWalletConnect() {
        mWalletConnectURI?.let {
            connectWalletConnect(it)
        }
    }

    private val processDisconnect = { _: Int, _: String? ->
        runOnUiThread {
            Toast.makeText(this@WalletConnectActivity, "disconnenct", Toast.LENGTH_SHORT).show()
            finish()
        }
    }

    private fun moveToBackIfNeed() {
        if (connectType == ConnectType.DeepLinkWalletConnect || connectType == ConnectType.DeepLinkWalletConnectCommon) {
            moveTaskToBack(
                true
            )
        }
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if (item.itemId == android.R.id.home) {
            finish()
            return true
        }
        return super.onOptionsItemSelected(item)
    }

    override fun onBackPressed() {
        if (connectType.isDapp() && binding.dappWebView.canGoBack()) {
            binding.dappWebView.goBack()
        } else {
            super.onBackPressed()
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        intent.data?.let { data ->
            if (!fromCosmostationScheme(data)) {
                return
            }

            if (WC_URL_SCHEME_HOST_WC == data.host) {
                if (isSessionConnected()) return
                mWalletConnectURI = data.query
                binding.loadingLayer.visibility = View.VISIBLE
                connectWalletConnect()
            } else if (WC_URL_SCHEME_HOST_DAPP_EXTERNAL == data.host || WC_URL_SCHEME_HOST_DAPP_INTERNAL == data.host) {
                if (!connectType.isDapp()) {
                    Toast.makeText(
                        this@WalletConnectActivity, "unknown", Toast.LENGTH_SHORT
                    ).show()
                } else {
                    data.query?.let { url -> binding.dappWebView.loadUrl(url) }
                }
            }
        }
    }

    private fun isSessionConnected(): Boolean {
        if (CoreClient.Pairing.getPairings().firstOrNull { it.isActive } != null) {
            return true
        }
        return false
    }

    override fun onDestroy() {
        val pairingList = CoreClient.Pairing.getPairings()
        pairingList.forEach { CoreClient.Pairing.disconnect(it.topic) }
        super.onDestroy()
    }

    private val dappWebChromeClient = object : WebChromeClient() {
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

    private val dappWebViewClient = object : WebViewClient() {
        override fun onPageFinished(view: WebView?, url: String?) {
            try {
                val inputStream = assets.open("injectScript.js")
                inputStream.bufferedReader().use(BufferedReader::readText)
            } catch (e: Exception) {
                null
            }?.let { view?.loadUrl("javascript:($it)()") }
        }

        override fun shouldOverrideUrlLoading(
            view: WebView, request: WebResourceRequest
        ): Boolean {
            var modifiedUrl = request.url.toString()
            if (isFinishing) {
                return true
            }
            if (modifiedUrl.startsWith(
                    "wc:"
                )
            ) {
                processConnectScheme(
                    modifiedUrl
                )
                return true
            } else if (modifiedUrl.startsWith(
                    "intent:"
                )
            ) {
                try {
                    val intent = Intent.parseUri(
                        modifiedUrl, Intent.URI_INTENT_SCHEME
                    )
                    val existPackage = intent.getPackage()?.let {
                        packageManager.getLaunchIntentForPackage(
                            it
                        )
                    }
                    existPackage?.let {
                        startActivity(
                            intent
                        )
                    } ?: run {
                        val marketIntent = Intent(
                            Intent.ACTION_VIEW
                        )
                        marketIntent.data = Uri.parse(
                            "market://details?id=" + intent.getPackage()
                        )
                        startActivity(
                            marketIntent
                        )
                    }
                    return true
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
            return false
        }
    }

    companion object {
        const val INTENT_WC_URL_KEY = "wcUrl"
        const val WC_URL_SCHEME_HOST_WC = "wc"
        const val WC_URL_SCHEME_HOST_DAPP_EXTERNAL = "dapp"
        const val WC_URL_SCHEME_HOST_DAPP_INTERNAL = "internaldapp"
        const val WC_URL_SCHEME_COSMOSTATION = "splashwallet"
        const val WC_URL_SCHEME_COMMON = "wc"
    }
}