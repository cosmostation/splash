package io.cosmostation.splash.ui.wallet

import SingleLiveEvent
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch

class ImportPrivateKeyViewModel : ViewModel() {
    val create = SingleLiveEvent<Any>()
    val privateKey = MutableLiveData<String>()

    fun createClick(name: String, privateKey: String) = viewModelScope.launch {}
}