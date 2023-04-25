package io.cosmostation.splash.model

sealed class SettingItem(val title: String, val type: SettingItemType) {
    class SwitchSettingItem(title: String, val icon: Int, val status: Boolean, val action: (checked: Boolean) -> Unit) : SettingItem(title, SettingItemType.SWITCH)
    class SectionSettingItem(title: String) : SettingItem(title, SettingItemType.SECTION)
    class ButtonSettingItem(title: String, val icon: Int, val badge: String, val action: () -> Unit) : SettingItem(title, SettingItemType.BUTTON)
}

enum class SettingItemType {
    SECTION, SWITCH, BUTTON
}
