package io.cosmostation.splash.ui.staking

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.google.gson.Gson
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.JsonRpcRequest
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject

class StakingViewModel : ViewModel() {
    val epoch = MutableLiveData<Long>()
    val epochEndMs = MutableLiveData<Long>()
    val totalBalance = MutableLiveData<Double>()
    val stakeInfos = MutableLiveData<String>()
    val validatorInfos = MutableLiveData<JSONArray>()

    fun loadInfo() = CoroutineScope(Dispatchers.IO).launch {
        SplashWalletApp.instance.applicationViewModel.suiSystemInfo.value?.let {
            val jsonObject = JSONObject(it)
            epoch.postValue(jsonObject.getLong("epoch"))
            epochEndMs.postValue(jsonObject.getLong("epochDurationMs") + jsonObject.getLong("epochStartTimestampMs"))
        }

        SplashWalletApp.instance.applicationViewModel.allBalances.value?.let {
            it.find { it.coinType == SplashConstants.SUI_BALANCE_DENOM }?.totalBalance?.let {
                totalBalance.postValue(it)
            }
        }
    }

    fun loadStakes() = CoroutineScope(Dispatchers.IO).launch {
        SplashWalletApp.instance.applicationViewModel.suiSystemInfo.value?.let {
            val jsonObject = JSONObject(it)
            validatorInfos.postValue(jsonObject.getJSONArray("activeValidators"))
        }

        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.let {
            try {
                val stakes = SuiClient.instance.fetchCustomRequest(JsonRpcRequest("suix_getStakes", listOf(it.address)))?.result
                stakes?.let {
                    stakeInfos.postValue(Gson().toJson(it))
                }
            } catch (_: Exception) {
            }
        }
    }
}