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

class StakingStakeViewModel : ViewModel() {
    val epoch = MutableLiveData<Long>()
    val epochEndMs = MutableLiveData<Long>()
    val totalBalance = MutableLiveData<String>()
    val stakeInfos = MutableLiveData<String>()
    val validatorInfos = MutableLiveData<Map<String, JSONObject>>()
    val validators = MutableLiveData<JSONArray>()

    fun loadInfo() = CoroutineScope(Dispatchers.IO).launch {
        SplashWalletApp.instance.applicationViewModel.suiSystemInfo.value?.let {
            val jsonObject = JSONObject(it)
            epoch.postValue(jsonObject.getLong("epoch"))
            epochEndMs.postValue(jsonObject.getLong("epochDurationMs") + jsonObject.getLong("epochStartTimestampMs"))
        }

    }

    fun loadStakes() = CoroutineScope(Dispatchers.IO).launch {
        SplashWalletApp.instance.applicationViewModel.suiSystemInfo.value?.let {
            val jsonObject = JSONObject(it)
            val validatorMap = mutableMapOf<String, JSONObject>()
            val items = jsonObject.getJSONArray("activeValidators")
            validators.postValue(items)
            for (i in 0 until items.length()) {
                val validator = items.getJSONObject(i)
                validatorMap[validator.getString("suiAddress")] = validator
            }
            validatorInfos.postValue(validatorMap)
        }

        SplashWalletApp.instance.applicationViewModel.allBalances.value?.let {
            it.find { it.coinType == SplashConstants.SUI_BALANCE_DENOM }?.totalBalance?.let {
                totalBalance.postValue(it)
            }
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