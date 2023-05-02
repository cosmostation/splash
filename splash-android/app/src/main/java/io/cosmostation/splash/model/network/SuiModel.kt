package io.cosmostation.splash.model.network

import org.json.JSONObject

data class Balance(
    val coinType: String, val coinObjectCount: Int, var totalBalance: Double
)

data class CoinMetadata(
    val description: String,
    val iconUrl: String?,
    val decimals: Int,
    val id: String,
    val name: String,
    val symbol: String
)

data class Dapp(
    val name: String,
    val description: String,
    val link: String,
    val icon: String,
    val tags: List<String>
)

data class SuiObject(
    val status: String, val details: ObjectDetails
)

data class ObjectDetails(val data: Any) {
    fun jsonData(): JSONObject {
        return JSONObject(data as Map<*, *>)
    }
}