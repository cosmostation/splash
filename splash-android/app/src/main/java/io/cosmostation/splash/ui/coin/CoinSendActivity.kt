package io.cosmostation.splash.ui.coin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.widget.addTextChangedListener
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
import io.cosmostation.splash.util.DecimalUtils
import io.cosmostation.splash.util.addDecimalCheckListener
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.SuiTransactionBlockResponseOptions
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.math.BigDecimal
import java.math.BigInteger
import java.math.RoundingMode
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
        binding.gas.text = DecimalUtils.toString(SplashConstants.DEFAULT_GAS_BUDGET.toLong(), 9, 9)
        binding.denom.text = denom?.substringAfterLast("::")
        binding.available.text = SplashWalletApp.instance.applicationViewModel.coinMap[denom]?.let {
            if (SplashConstants.SUI_BALANCE_DENOM == denom) {
                DecimalUtils.toString(it.totalBalance - SplashConstants.DEFAULT_GAS_BUDGET.toLong())
            } else {
                DecimalUtils.toString(it.totalBalance)
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
                    DecimalUtils.toString(it.totalBalance - SplashConstants.DEFAULT_GAS_BUDGET, meta.decimals)
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
            if (binding.address.text.isEmpty()) {
                Toast.makeText(this, "Empty receiver", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }
            if (binding.amount.text.isEmpty() || BigDecimal(binding.amount.text.toString()) <= BigDecimal(0)) {
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
                            suiCoins.mapNotNull { it?.objectId }, listOf(binding.address.text.toString()), SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address, SplashConstants.DEFAULT_GAS_BUDGET, listOf(
                                BigDecimal(binding.amount.text.toString()).multiply(
                                    BigDecimal(10).pow(metadata?.decimals ?: 9)
                                ).toBigInteger()
                            )
                        )
                        val txBytes = Base64.getDecoder().decode(objects!!.txBytes)
                        val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                        val keyPair = SuiClient.instance.getKeyPair(SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.mnemonic)
                        val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                        val executeResult = SuiClient.instance.executeTransaction(
                            txBytes, signedTxBytes, keyPair, SuiTransactionBlockResponseOptions(showInput = true, showEffects = true)
                        )
                        startActivity(
                            Intent(
                                this@CoinSendActivity, TransactionResultActivity::class.java
                            ).putExtra("executeResult", Gson().toJson(executeResult))
                        )
                        finish()
                    } else {
                        val objects = SuiClient.instance.pay(
                            currentCoins.mapNotNull { it?.objectId }, listOf(binding.address.text.toString()), SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address, SplashConstants.DEFAULT_GAS_BUDGET * 2, null, listOf(
                                BigDecimal(binding.amount.text.toString()).multiply(
                                    BigDecimal(10).pow(metadata?.decimals ?: 9)
                                ).toBigInteger()
                            )
                        )
                        val txBytes = Base64.getDecoder().decode(objects!!.txBytes)
                        val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                        val keyPair = SuiClient.instance.getKeyPair(SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.mnemonic)
                        val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                        val executeResult = SuiClient.instance.executeTransaction(txBytes, signedTxBytes, keyPair, SuiTransactionBlockResponseOptions(showInput = true, showEffects = true))
                        startActivity(
                            Intent(
                                this@CoinSendActivity, TransactionResultActivity::class.java
                            ).putExtra("executeResult", Gson().toJson(executeResult))
                        )
                        finish()
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