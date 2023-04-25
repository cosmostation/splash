package io.cosmostation.splash.ui.staking.stake

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.google.gson.Gson
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.api.SuiUtilService
import io.cosmostation.splash.model.network.StakeRequest
import io.cosmostation.splash.model.network.TransactionBlock
import io.cosmostation.splash.model.network.UnstakeRequest
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
import java.math.BigDecimal
import java.math.BigInteger

class StakeViewModel : ViewModel() {
    val error = MutableLiveData<String>()
    val result = MutableLiveData<String>()

    fun stake(item: JSONObject, amount: String) = CoroutineScope(Dispatchers.IO).launch {
        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.let { wallet ->
            val validatorAddress = item.getString("suiAddress")
            val signer = wallet.address
            SuiUtilService.create().buildStakingRequest(StakeRequest(validatorAddress, signer, BigDecimal(amount).multiply(BigDecimal(10).pow(9)).toString(), SuiClient.instance.currentNetwork.rpcUrl)).enqueue(object : Callback<String> {
                override fun onResponse(call: Call<String>, response: Response<String>) {
                    try {
                        val txBytes = Utils.hexToBytes(response.body())
                        val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                        val mnemonic = wallet.mnemonic
                        val keyPair = SuiClient.instance.getKeyPair(mnemonic)
                        val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                        CoroutineScope(Dispatchers.IO).launch {
                            val executeResult = SuiClient.instance.executeTransaction(
                                txBytes, signedTxBytes, keyPair, SuiTransactionBlockResponseOptions(showInput = true, showEffects = true, showEvents = true)
                            )
                            result.postValue(Gson().toJson(executeResult))
                        }
                    } catch (e: Exception) {
                        error.postValue(e.message)
                    }
                }

                override fun onFailure(call: Call<String>, t: Throwable) {
                    error.postValue(t.message)
                }
            })
        }
    }

    fun unstake(item: JSONObject) = CoroutineScope(Dispatchers.IO).launch {
        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.let { wallet ->
            val objectId = item.getString("stakedSuiId")
            val signer = wallet.address
            SuiUtilService.create().buildUnstakingRequest(UnstakeRequest(objectId, signer, SuiClient.instance.currentNetwork.rpcUrl)).enqueue(object : Callback<String> {
                override fun onResponse(call: Call<String>, response: Response<String>) {
                    try {
                        val txBytes = Utils.hexToBytes(response.body())
                        val intentMessage = byteArrayOf(0, 0, 0) + txBytes
                        val mnemonic = wallet.mnemonic
                        val keyPair = SuiClient.instance.getKeyPair(mnemonic)
                        val signedTxBytes = SuiClient.instance.sign(keyPair, intentMessage)
                        CoroutineScope(Dispatchers.IO).launch {
                            val executeResult = SuiClient.instance.executeTransaction(
                                txBytes, signedTxBytes, keyPair, SuiTransactionBlockResponseOptions(showInput = true, showEffects = true, showEvents = true)
                            )
                            result.postValue(Gson().toJson(executeResult))
                        }
                    } catch (e: Exception) {
                        error.postValue(e.message)
                    }
                }

                override fun onFailure(call: Call<String>, t: Throwable) {
                    error.postValue(t.message)
                }
            })
        }
    }
}