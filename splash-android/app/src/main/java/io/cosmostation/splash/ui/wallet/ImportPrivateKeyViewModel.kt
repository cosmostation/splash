package io.cosmostation.splash.ui.wallet

import SingleLiveEvent
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.database.AppDatabase
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.util.Prefs
import kotlinx.coroutines.launch

class ImportPrivateKeyViewModel : ViewModel() {
    val create = SingleLiveEvent<Any>()
    val privateKey = MutableLiveData<String>()

    fun createByPrivateKey(name: String, privateKey: String) = viewModelScope.launch {
        val wallet = Wallet.createByPrivateKey(name, privateKey)
        val id = AppDatabase.getInstance().walletDao().insert(wallet)
        Prefs.currentWalletId = id
        SplashWalletApp.instance.applicationViewModel.loadWallet()
        create.postValue(Unit)
    }

}