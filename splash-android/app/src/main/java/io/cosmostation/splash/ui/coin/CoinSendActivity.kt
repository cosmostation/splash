package io.cosmostation.splash.ui.coin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import coil.ImageLoader
import coil.decode.SvgDecoder
import coil.request.ImageRequest
import coil.transform.RoundedCornersTransformation
import com.google.gson.Gson
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.ActivityTokenSendBinding
import io.cosmostation.splash.model.network.CoinMetadata
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.common.LoadingFragment
import io.cosmostation.splash.ui.password.PinActivity
import io.cosmostation.splash.ui.transaction.TransactionResultActivity
import io.cosmostation.splash.util.*
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.Network
import io.cosmostation.suikotlin.model.SuiTransactionBlockResponseOptions
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.math.BigDecimal
import java.math.BigInteger
import java.util.*

class CoinSendActivity : ActionBarBaseActivity() {
    companion object {
        const val INTENT_DENOM_KEY = "denom"
    }

    private lateinit var binding: ActivityTokenSendBinding
    override val titleResourceId: Int
        get() = R.string.send

    private var metadata: CoinMetadata? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityTokenSendBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        loadData()
    }

    private fun loadData() {
        val denom = intent.getStringExtra(INTENT_DENOM_KEY)
        binding.network.visibleOrGone(SuiClient.instance.currentNetwork.name != Network.Mainnet().name)
        binding.network.text = SuiClient.instance.currentNetwork.name
        binding.gas.text = GasUtils.getDefaultGas().formatGasDecimal()
        binding.denom.text = denom?.substringAfterLast("::")
        binding.available.text = SplashWalletApp.instance.applicationViewModel.coinMap[denom]?.let {
            if (SplashConstants.SUI_BALANCE_DENOM == denom) {
                BigInteger(it.totalBalance).minus(GasUtils.getDefaultGas()).formatDecimal(trim = 9)
            } else {
                it.totalBalance.formatDecimal(trim = 9)
            }
        }
        if (SplashConstants.SUI_BALANCE_DENOM == denom) {
            binding.logo.setImageResource(R.drawable.token_sui)
        } else {
            binding.logo.setImageResource(R.drawable.token_default)
        }
        SplashWalletApp.instance.applicationViewModel.coinMetadataMap.value?.let {
            metadata = it[denom]
            metadata?.let { meta ->
                binding.denom.text = meta.symbol
                binding.available.text = SplashWalletApp.instance.applicationViewModel.coinMap[denom]?.let {
                    if (SplashConstants.SUI_BALANCE_DENOM == denom) {
                        BigInteger(it.totalBalance).minus(GasUtils.getDefaultGas()).formatDecimal(trim = 9)
                    } else {
                        BigInteger(it.totalBalance).formatDecimal(meta.decimals, 9)
                    }
                }
                meta.iconUrl?.let { url ->
                    val imageLoader = ImageLoader.Builder(this).components {
                        add(SvgDecoder.Factory())
                    }.placeholder(R.drawable.token_default).build()
                    val request = ImageRequest.Builder(this).data(url).target(binding.logo).transformations(RoundedCornersTransformation(20f)).build()
                    val disposable = imageLoader.enqueue(request)
                }
            }
        }
    }

    private fun setupViews() {
        val resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                dialog.show(supportFragmentManager, LoadingFragment::class.java.name)
                doSend()
            }
        }
        binding.nextBtn.setOnClickListener {
            if (binding.address.text?.isEmpty() == true) {
                Toast.makeText(this, "Empty receiver", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }
            if (binding.amount.text?.isEmpty() == true || BigDecimal(binding.amount.text.toString()) <= BigDecimal(0)) {
                Toast.makeText(this, "Empty amount", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }
            if (BigDecimal(binding.amount.text.toString()) > BigDecimal(binding.available.text.toString())) {
                Toast.makeText(this, "Not enough amount", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }
            resultLauncher.launch(Intent(this, PinActivity::class.java))
        }

        binding.amount.addDecimalCheckListener({ binding.available.text.toString() }, metadata?.decimals ?: 9)
    }

    private fun doSend() {
        val denom = intent.getStringExtra(INTENT_DENOM_KEY) ?: SplashConstants.SUI_BALANCE_DENOM
        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.let {
            val suiCoins = SplashWalletApp.instance.applicationViewModel.allObjectsMetaLiveData.value?.filter {
                it?.type?.contains(SplashConstants.SUI_BALANCE_DENOM) == true
            } ?: listOf()
            val currentCoins = SplashWalletApp.instance.applicationViewModel.allObjectsMetaLiveData.value?.filter {
                it?.type?.contains(denom) == true
            } ?: listOf()
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    if (denom == SplashConstants.SUI_BALANCE_DENOM) {
                        val objects = SuiClient.instance.paySui(
                            suiCoins.mapNotNull { it?.objectId }, listOf(binding.address.text.toString()), SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address, GasUtils.getDefaultGas(), listOf(
                                binding.amount.text.toString().parseDecimal(metadata?.decimals ?: 9)
                            )
                        )
                        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.let { wallet ->
                            val keyPair = wallet.mnemonic?.let {
                                SuiClient.instance.getKeyPair(it)
                            } ?: wallet.privateKey?.let {
                                SuiClient.instance.getKeyPairByPrivateKey(it)
                            }
                            keyPair?.let {
                                val txBytes = Base64.getDecoder().decode(objects!!.txBytes)
                                val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                                val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                                val executeResult = SuiClient.instance.executeTransaction(txBytes, signedTxBytes, keyPair, SuiTransactionBlockResponseOptions(showInput = true, showEffects = true))
                                startActivity(Intent(this@CoinSendActivity, TransactionResultActivity::class.java).putExtra("executeResult", Gson().toJson(executeResult)))
                            }
                            finish()
                        }
                    } else {
                        val objects = SuiClient.instance.pay(
                            currentCoins.mapNotNull { it?.objectId }, listOf(binding.address.text.toString()), SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address, GasUtils.getDefaultGas(), null, listOf(
                                binding.amount.text.toString().parseDecimal(metadata?.decimals ?: 9)
                            )
                        )
                        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.let { wallet ->
                            val keyPair = wallet.mnemonic?.let {
                                SuiClient.instance.getKeyPair(it)
                            } ?: wallet.privateKey?.let {
                                SuiClient.instance.getKeyPairByPrivateKey(it)
                            }
                            keyPair?.let {
                                val txBytes = Base64.getDecoder().decode(objects!!.txBytes)
                                val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                                val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                                val executeResult = SuiClient.instance.executeTransaction(txBytes, signedTxBytes, keyPair, SuiTransactionBlockResponseOptions(showInput = true, showEffects = true))
                                startActivity(Intent(this@CoinSendActivity, TransactionResultActivity::class.java).putExtra("executeResult", Gson().toJson(executeResult)))
                                finish()
                            }
                        }
                    }
                } catch (e: Exception) {
                    runOnUiThread {
                        Toast.makeText(this@CoinSendActivity, "Error !", Toast.LENGTH_LONG).show()

                    }
                } finally {
                    dialog.dismiss()
                }
            }
        }
    }
}