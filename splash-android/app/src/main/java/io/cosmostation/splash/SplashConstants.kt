package io.cosmostation.splash

import io.cosmostation.splash.api.SplashResourceService
import io.cosmostation.suikotlin.model.Network
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

object SplashConstants {
    const val IPFS = "https://ipfs.io/ipfs/"
    const val SUI_DENOM = "0x2::coin::Coin<0x2::sui::SUI>"
    const val SUI_BALANCE_DENOM = "0x2::sui::SUI"
    const val SUI_STAKED_BALANCE_DENOM = "0x2::sui::StakedSUI"
    const val COINGECKO_SUI_ID = "sui"
    const val SPLASH_GITHUB = "https://github.com/cosmostation/splash"
    const val SPLASH_TWITTER = "https://twitter.com/splash_sui"
    const val SPLASH_PLAY_STORE = "https://play.google.com/store/apps/details?id=io.cosmostation.splash"
    const val SPLASH_EMAIL = "splash@cosmostation.io"
    var suiFees: Map<String, Map<String, String>>? = null
    var networks: Map<String, Network> = mapOf("Mainnet" to Network.Mainnet(), "Testnet" to Network.Testnet(), "Devnet" to Network.Devnet(), "Localnet" to Network.Localnet())
    val coingeckoIdMap = mapOf(SUI_BALANCE_DENOM to COINGECKO_SUI_ID, SUI_STAKED_BALANCE_DENOM to COINGECKO_SUI_ID)

    init {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                suiFees = SplashResourceService.create().fee().body()
            } catch (_: Exception) {
            }
        }
    }

    fun txDetailUrl(address: String, network: String): String {
        return "https://explorer.sui.io/transactions/$address?network=${network.lowercase()}"
    }

    fun objectDetailUrl(objectId: String, network: String): String {
        return "https://explorer.sui.io/object/$objectId?network=${network.lowercase()}"
    }

    fun accountDetailUrl(address: String, network: String): String {
        return "https://explorer.sui.io/address/$address?network=${network.lowercase()}"
    }
}