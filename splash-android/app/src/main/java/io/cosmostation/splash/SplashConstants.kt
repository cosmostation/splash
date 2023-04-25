package io.cosmostation.splash

object SplashConstants {
    const val IPFS = "https://ipfs.io/ipfs/"
    const val SUI_DENOM = "0x2::coin::Coin<0x2::sui::SUI>"
    const val DEFAULT_GAS_BUDGET = 2000000
    const val SUI_BALANCE_DENOM = "0x2::sui::SUI"
    const val SPLASH_GITHUB = "https://github.com/cosmostation/splash"
    const val SPLASH_TWITTER = "https://twitter.com/splash_sui"
    const val SPLASH_PLAY_STORE = "https://play.google.com/store/apps/details?id=io.cosmostation.splash"
    const val SPLASH_EMAIL = "splash@cosmostation.io"

    fun txDetailUrl(address: String): String {
        return "https://explorer.sui.io/transactions/$address"
    }

    fun objectDetailUrl(objectId: String): String {
        return "https://explorer.sui.io/object/$objectId"
    }
}