package io.cosmostation.splash

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.MutableLiveData
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.cosmostation.splash.api.CoingeckoService
import io.cosmostation.splash.database.AppDatabase
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.model.network.Balance
import io.cosmostation.splash.model.network.CoinMetadata
import io.cosmostation.splash.util.Prefs
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.key.SuiKey
import io.cosmostation.suikotlin.model.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.lang.reflect.Type

class ApplicationViewModel(application: Application) : AndroidViewModel(application) {
    var currentWalletLiveData = MutableLiveData<Wallet?>()
    var allObjectsMetaLiveData = MutableLiveData<List<SuiObjectInfo?>?>()
    var allObjectsLiveData = MutableLiveData<List<SuiObjectInfo>?>()
    val allBalances = MutableLiveData<List<Balance>>()
    var allTransactionsLiveData = MutableLiveData<List<SuiTransaction>?>()
    var fetchCount = MutableLiveData(0)
    var coinMap = mapOf<String, Balance>()
    val nftMap = mutableMapOf<String, SuiObjectInfo>()
    val coinMetadataMap = MutableLiveData<Map<String, CoinMetadata?>>()
    val suiSystemInfo = MutableLiveData<String?>()
    var priceMap = MutableLiveData<Map<String, Map<String, Double>>?>()
    var dynamicFieldData = MutableLiveData<List<String?>>()
    var allMultiObjectsMetaLiveData = MutableLiveData<List<SuiObjectInfo>?>()

    fun loadAllData() {
        loadSuiSystem()
        loadBalances()
        loadObjects()
        loadTransactions()
    }

    private fun loadPrice(coinTypes: List<String>) = CoroutineScope(Dispatchers.IO).launch {
        try {
            val result = CoingeckoService.create().price(coinTypes.mapNotNull { SplashConstants.coingeckoIdMap[it] }.toSet(), "usd", true).body()
            priceMap.postValue(result)
        } catch (e: Exception) {
            print(e)
        }
    }

    private fun loadSuiSystem() = CoroutineScope(Dispatchers.IO).launch {
        suiSystemInfo.postValue(null)
        increaseFetchCount()
        try {
            val objects = SuiClient.instance.fetchCustomRequest(JsonRpcRequest("suix_getLatestSuiSystemState", listOf()))?.result
            objects?.let {
                suiSystemInfo.postValue(Gson().toJson(it))
            }
        } catch (_: Exception) {
        } finally {
            decreaseFetchCount()
        }
    }

    private fun loadCoinMetadata(coinTypes: List<String>) = CoroutineScope(Dispatchers.IO).launch {
        coinMetadataMap.postValue(mapOf())
        coinTypes.forEach {
            val result = SuiClient.instance.fetchCustomRequest(JsonRpcRequest("suix_getCoinMetadata", listOf(it)))?.result
            val meta = Gson().fromJson(Gson().toJson(result), CoinMetadata::class.java)
            val map = (coinMetadataMap.value ?: mutableMapOf()).toMutableMap()
            map[it] = meta
            coinMetadataMap.postValue(map)
        }
    }

    private fun loadBalances() = CoroutineScope(Dispatchers.IO).launch {
        allBalances.postValue(listOf(Balance(SplashConstants.SUI_BALANCE_DENOM, 0, "0")))
        currentWalletLiveData.value?.address?.let {
            increaseFetchCount()

            try {
                val response = SuiClient.instance.fetchCustomRequest(JsonRpcRequest("suix_getAllBalances", listOf(it)))
                val balanceListType: Type = object : TypeToken<List<Balance>>() {}.type
                val result: MutableList<Balance> = Gson().fromJson(Gson().toJson(response?.result), balanceListType)
                if (result.isEmpty()) {
                    result.add(Balance(SplashConstants.SUI_BALANCE_DENOM, 0, "0"))
                }
                allBalances.postValue(result)
                coinMap = result.associateBy { it.coinType }
                loadCoinMetadata(result.map { it.coinType })
                loadPrice(result.map { it.coinType })
            } catch (_: Exception) {
                allBalances.postValue(listOf(Balance(SplashConstants.SUI_BALANCE_DENOM, 0, "0")))
            } finally {
                decreaseFetchCount()
            }
        }
    }

    fun increaseFetchCount() {
        fetchCount.value?.let {
            fetchCount.postValue(it + 1)
        } ?: run {
            fetchCount.postValue(1)
        }
    }

    fun decreaseFetchCount() {
        fetchCount.value?.let {
            fetchCount.postValue(Integer.max(0, it - 1))
        } ?: run {
            fetchCount.postValue(0)
        }
    }

    private fun loadObjects() = CoroutineScope(Dispatchers.IO).launch {
        allObjectsLiveData.postValue(listOf())
        allObjectsMetaLiveData.postValue(listOf())
        currentWalletLiveData.value?.address?.let {
            increaseFetchCount()
            try {
                val objects = SuiClient.instance.getObjectsByOwner(it, SuiObjectDataOptions(showContent = true, showDisplay = true))
                allObjectsMetaLiveData.postValue(objects)
                if (objects.isEmpty()) {
                    return@launch
                }
                aggregateNfts(objects)
                allObjectsLiveData.postValue(objects)
            } catch (_: Exception) {
            } finally {
                decreaseFetchCount()
            }
        }
    }

    fun loadDynamicFields(objectId: String?) = CoroutineScope(Dispatchers.IO).launch {
        try {
            val objectIdList = mutableListOf<String>()
            objectId?.let {
                val dynamicFields = SuiClient.instance.fetchCustomRequest(JsonRpcRequest("suix_getDynamicFields", listOf(it)))?.result
                dynamicFields?.let { field ->
                    val jsonField = JSONObject(Gson().toJson(field)).getJSONArray("data")
                    for (i in 0 until jsonField.length()) {
                        val fieldType = jsonField.getJSONObject(i).getJSONObject("name").getString("type")
                        if (fieldType.contains("0x2::kiosk::Item")) {
                            val objectId = jsonField.getJSONObject(i).getJSONObject("name").getJSONObject("value").getString("id")
                            objectIdList.add(objectId)
                        }
                    }
                    dynamicFieldData.postValue(objectIdList)
                }
            }
        } catch (_: Exception) { }
    }

    fun loadMultiObjects() = CoroutineScope(Dispatchers.IO).launch {
        dynamicFieldData.value?.let {
            try {
                val objects = SuiClient.instance.getMultiObjectsById(it, SuiObjectDataOptions(showContent = true, showDisplay = true))
                allMultiObjectsMetaLiveData.postValue(objects)
                if (objects.isEmpty()) {
                    return@launch
                }
            } catch (_: Exception) { }
        }
    }

    private fun aggregateNfts(objects: List<SuiObjectInfo>) {
        nftMap.clear()
        objects.filter { !it.type.contains("Coin") }.forEach {
            val id = it.objectId
            nftMap[id] = it
        }
    }

    fun loadTransactions() = CoroutineScope(Dispatchers.IO).launch {
        allTransactionsLiveData.postValue(listOf())
        currentWalletLiveData.value?.address?.let { address ->
            increaseFetchCount()
            try {
                val from = SuiClient.instance.getTransactions(
                    TransactionQuery.FromAddress(address), limit = 50, descending = true
                )
                val to = SuiClient.instance.getTransactions(
                    TransactionQuery.ToAddress(address), limit = 50, descending = true
                )
                val transactions = from + to
                allTransactionsLiveData.postValue(transactions)
            } catch (_: Exception) {
            } finally {
                decreaseFetchCount()
            }
        }
    }

    fun loadWallet(force: Boolean = false) {
        CoroutineScope(Dispatchers.IO).launch {
            if (!force && currentWalletLiveData.value?.id == Prefs.currentWalletId) {
                return@launch
            }

            val entity = AppDatabase.getInstance().walletDao().selectById(Prefs.currentWalletId)
            entity?.let { wallet ->
                wallet.mnemonic?.let { mnemonic ->
                    if (wallet.address != SuiKey.getSuiAddress(mnemonic)) {
                        wallet.address = SuiKey.getSuiAddress(mnemonic)
                        AppDatabase.getInstance().walletDao().insert(wallet)
                    }
                }
            }
            var currentWallet: Wallet? = null
            entity?.let {
                currentWallet = it
            } ?: run {
                val wallets = AppDatabase.getInstance().walletDao().selectAll()
                if (wallets.isEmpty()) {
                    null
                } else {
                    wallets.first().apply {
                        Prefs.currentWalletId = this.id
                        currentWallet = this
                    }
                }
            }

            currentWalletLiveData.postValue(currentWallet)
        }
    }
}