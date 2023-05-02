package io.cosmostation.splash.ui.activity

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import io.cosmostation.suikotlin.model.SuiTransaction
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class ActivityViewModel : ViewModel() {
    val activities = MutableLiveData<List<SuiTransaction>>()

    fun loadActivities(transactions: List<SuiTransaction>) = CoroutineScope(Dispatchers.IO).launch {
        val activities = transactions.distinctBy { it.digest }.sortedByDescending { it.timestampMs }
        this@ActivityViewModel.activities.postValue(activities)
    }
}