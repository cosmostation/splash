package io.cosmostation.splash.model.network

data class Balance(
    val coinType: String, val coinObjectCount: Int, var totalBalance: String
)

data class CoinMetadata(
    val description: String, val iconUrl: String?, val decimals: Int, val id: String, val name: String, val symbol: String
)

data class Dapp(
    val name: String, val description: String, val link: String, val icon: String, val tags: List<String>
)