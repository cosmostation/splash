package io.cosmostation.splash.ui.coin

import SingleLiveEvent
import androidx.lifecycle.ViewModel
import io.cosmostation.suikotlin.SuiClient
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class CoinViewModel : ViewModel() {
    val faucet = SingleLiveEvent<Boolean>()
    val toast = SingleLiveEvent<String>()

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
}