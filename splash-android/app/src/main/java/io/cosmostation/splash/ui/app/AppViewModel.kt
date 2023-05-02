package io.cosmostation.splash.ui.app

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import io.cosmostation.splash.api.SplashResourceService
import io.cosmostation.splash.model.network.Dapp
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class AppViewModel : ViewModel() {
    val apps = MutableLiveData<List<Dapp>>()

    fun loadApps() = CoroutineScope(Dispatchers.IO).launch {
        SplashResourceService.create().dapp().body()?.let {
            apps.postValue(it)
        }
    }
}
