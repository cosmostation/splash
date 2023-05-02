package io.cosmostation.splash.ui.staking.validator

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import io.cosmostation.splash.SplashWalletApp
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject

class SelectValidatorViewModel : ViewModel() {
    val validatorInfos = MutableLiveData<JSONArray>()

    fun loadValidatorInfo() = CoroutineScope(Dispatchers.IO).launch {
        SplashWalletApp.instance.applicationViewModel.suiSystemInfo.value?.let {
            val jsonObject = JSONObject(it)
            validatorInfos.postValue(jsonObject.getJSONArray("activeValidators"))
        }
    }
}