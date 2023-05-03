package io.cosmostation.splash.ui.nft

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import com.google.gson.Gson
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.ActivityNftSendBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.common.LoadingFragment
import io.cosmostation.splash.ui.password.PinActivity
import io.cosmostation.splash.ui.transaction.TransactionResultActivity
import io.cosmostation.splash.util.GasUtils
import io.cosmostation.splash.util.formatGasDecimal
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.SuiTransactionBlockResponseOptions
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.util.*

class NftSendActivity : ActionBarBaseActivity() {

    private lateinit var binding: ActivityNftSendBinding
    override val titleResourceId: Int
        get() = R.string.nft_send

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityNftSendBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        loadData()
    }

    private fun loadData() {
        val id = intent.getStringExtra("id")
        binding.gas.text = GasUtils.getDefaultGas().formatGasDecimal()
        id?.let {
            val objects = SplashWalletApp.instance.applicationViewModel.nftMap[it]
            objects?.let {
                binding.objectId.text = id
                binding.type.text = objects.type
                try {
                    val contentJson = JSONObject(Gson().toJson(it.content))
                    binding.image.setImageURI(
                        contentJson.getJSONObject("fields").getString("img_url").replace("ipfs://", SplashConstants.IPFS)
                    )
                    binding.title.text = contentJson.getJSONObject("fields").getString("name")
                } catch (_: Exception) {
                }
            }
        }
    }

    private fun setupViews() {
        val resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                dialog.show(supportFragmentManager, LoadingFragment::class.java.name)
                send()
            }
        }
        binding.nextBtn.setOnClickListener {
            if (binding.address.text.isEmpty()) {
                Toast.makeText(this, "Empty receiver", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }
            resultLauncher.launch(Intent(this, PinActivity::class.java))
        }
    }

    private fun send() {
        binding.loading.visibility = View.VISIBLE
        val id = intent.getStringExtra("id")
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val objects = SuiClient.instance.transferObject(id!!, binding.address.text.toString(), SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address, GasUtils.getDefaultGas())
                val txBytes = Base64.getDecoder().decode(objects!!.txBytes)
                val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                val keyPair = SuiClient.instance.getKeyPair(SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.mnemonic)
                val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                val executeResult = SuiClient.instance.executeTransaction(
                    txBytes, signedTxBytes, keyPair, SuiTransactionBlockResponseOptions(showInput = true, showEffects = true)
                )
                startActivity(
                    Intent(
                        this@NftSendActivity, TransactionResultActivity::class.java
                    ).putExtra("executeResult", Gson().toJson(executeResult))
                )
                finish()
            } catch (e: Exception) {
                runOnUiThread {
                    Toast.makeText(this@NftSendActivity, "Error !", Toast.LENGTH_LONG).show()
                    binding.loading.visibility = View.GONE
                }
            } finally {
                dialog.dismiss()
            }
        }
    }
}