package io.cosmostation.splash.ui.account

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import io.cosmostation.splash.database.AppDatabase
import io.cosmostation.splash.database.Wallet
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class AccountViewModel : ViewModel() {
    val wallets = MutableLiveData<List<Wallet>>()

    fun loadWallets() = CoroutineScope(Dispatchers.IO).launch {
        wallets.postValue(AppDatabase.getInstance().walletDao().selectAll())
    }

    fun deleteWallet(entity: Wallet) = CoroutineScope(Dispatchers.IO).launch {
        AppDatabase.getInstance().walletDao().delete(entity)
        wallets.postValue(AppDatabase.getInstance().walletDao().selectAll())
    }

    fun updateWallet(entity: Wallet) = CoroutineScope(Dispatchers.IO).launch {
        AppDatabase.getInstance().walletDao().insert(entity)
        wallets.postValue(AppDatabase.getInstance().walletDao().selectAll())
    }
}