package io.cosmostation.splash.ui.wallet

import SingleLiveEvent
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.database.AppDatabase
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.secure.SplashCipherHelper
import io.cosmostation.splash.util.Prefs
import io.cosmostation.suikotlin.SuiClient
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class ImportPrivateKeyViewModel : ViewModel() {
    val create = SingleLiveEvent<Any>()
    val privateKey = MutableLiveData<String>()

    fun createClick(name: String, privateKey: String) = viewModelScope.launch {}
}