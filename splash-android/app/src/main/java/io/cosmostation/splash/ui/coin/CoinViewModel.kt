package io.cosmostation.splash.ui.coin

import SingleLiveEvent
import androidx.lifecycle.ViewModel
import com.google.gson.Gson
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.JsonRpcRequest
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONArray
import java.math.BigInteger

class CoinViewModel : ViewModel() {
    val faucet = SingleLiveEvent<Boolean>()
    val toast = SingleLiveEvent<String>()
    val stakeAmount = SingleLiveEvent<String>()


    fun faucetClick(address: String) = CoroutineScope(Dispatchers.IO).launch {
        try {
            val body = SuiClient.instance.faucet(address)
            if (body == null) {
                faucet.postValue(false)
            } else {
                faucet.postValue(true)
            }
        } catch (_: Exception) {
            faucet.postValue(false)
        }
    }

    fun loadStake(address: String) = CoroutineScope(Dispatchers.IO).launch {
        try {
            val stakes = SuiClient.instance.fetchCustomRequest(JsonRpcRequest("suix_getStakes", listOf(address)))?.result
            stakes?.let {
                val jsonStake = JSONArray(Gson().toJson(it))
                var reward = BigInteger.ZERO
                var principal = BigInteger.ZERO
                for (i in 0 until jsonStake.length()) {
                    val stakeInfo = jsonStake.getJSONObject(i)
                    val stakeItemList = stakeInfo.getJSONArray("stakes")
                    for (j in 0 until stakeItemList.length()) {
                        val stakeItem = stakeItemList.getJSONObject(j)
                        if (stakeItem.has("principal")) {
                            principal += BigInteger(stakeItem.getString("principal"))
                        }
                        if (stakeItem.has("estimatedReward")) {
                            reward += BigInteger(stakeItem.getString("estimatedReward"))
                        }
                    }
                }
                stakeAmount.postValue((principal + reward).toString())
            }
        } catch (_: Exception) {
        }
    }
}