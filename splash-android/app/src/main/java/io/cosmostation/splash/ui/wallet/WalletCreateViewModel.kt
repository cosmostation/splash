package io.cosmostation.splash.ui.wallet

import SingleLiveEvent
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.database.AppDatabase
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.util.Prefs
import io.cosmostation.suikotlin.SuiClient
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class WalletCreateViewModel : ViewModel() {
    val create = SingleLiveEvent<Any>()
    val mnemonic = MutableLiveData<String>()

    fun createByMnemonic(name: String, mnemonic: String) = viewModelScope.launch {
        val wallet = Wallet.createByMnemonic(name, mnemonic)
        val id = AppDatabase.getInstance().walletDao().insert(wallet)
        Prefs.currentWalletId = id
        SplashWalletApp.instance.applicationViewModel.loadWallet()
        create.postValue(Unit)
    }

    fun generateMnemonic() = CoroutineScope(Dispatchers.IO).launch {
        mnemonic.postValue(SuiClient.instance.generateMnemonic())
    }
}