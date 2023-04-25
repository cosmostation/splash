package io.cosmostation.splash.util

import android.content.Context
import android.content.res.Configuration
import android.os.Build
import androidx.appcompat.app.AppCompatDelegate

object ThemeUtils {

    var LIGHT_MODE = "Light"
    var DARK_MODE = "Dark"
    var DEFAULT_MODE = "System"

    fun applyTheme(themeColor: String?) {
        when (themeColor) {
            LIGHT_MODE -> AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
            DARK_MODE -> AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
            DEFAULT_MODE ->
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM)
                } else {
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_AUTO_BATTERY)
                }
        }
    }

    fun modSave(context: Context, selectMod: String?) {
        val sp = context.getSharedPreferences("PRE_THEME_MOD", Context.MODE_PRIVATE)
        val editor = sp.edit()
        editor.putString("PRE_THEME_MOD", selectMod)
        editor.apply()
    }

    fun currentMode(context: Context): String? {
        return if (DEFAULT_MODE == modLoad(context) || modLoad(context)!!.isEmpty()) {
            val nightModeFlags = context.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
            if (nightModeFlags == Configuration.UI_MODE_NIGHT_YES) {
                DARK_MODE
            } else {
                LIGHT_MODE
            }
        } else {
            modLoad(context)
        }
    }

    fun modLoad(context: Context): String? {
        val sp = context.getSharedPreferences("PRE_THEME_MOD", Context.MODE_PRIVATE)
        return sp.getString("PRE_THEME_MOD", "")
    }
}