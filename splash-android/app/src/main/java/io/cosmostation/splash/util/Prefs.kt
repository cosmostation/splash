package io.cosmostation.splash.util

import SecureSharedPreferences
import android.content.SharedPreferences
import io.cosmostation.splash.SplashWalletApp

object Prefs {
    private const val PREFS_FILENAME = "io.cosmostation.splash"
    private const val CURRENT_WALLET_ID = "current_wallet_id"
    private const val CURRENT_NETWORK = "current_network"
    private const val PIN = "secured_pin"
    private const val SETTING_APP_LOCK = "setting_app_lock"

    private val preference: SharedPreferences = SplashWalletApp.instance.getSharedPreferences(PREFS_FILENAME, 0)

    var currentWalletId: Long
        get() = preference.getLong(CURRENT_WALLET_ID, -1L)
        set(value) = preference.edit().putLong(CURRENT_WALLET_ID, value).apply()

    var network: String
        get() = preference.getString(CURRENT_NETWORK, "Devnet") ?: "Devnet"
        set(value) = preference.edit().putString(CURRENT_NETWORK, value).apply()

    var pin: String
        get() = SecureSharedPreferences.wrap(preference).get(PIN, "")
        set(value) = SecureSharedPreferences.wrap(preference).putString(PIN, value)

    var settingAppLock: Boolean
        get() = preference.getBoolean(SETTING_APP_LOCK, true)
        set(value) = preference.edit().putBoolean(SETTING_APP_LOCK, value).apply()
}