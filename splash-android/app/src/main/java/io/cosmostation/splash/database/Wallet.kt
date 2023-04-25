package io.cosmostation.splash.database

import androidx.room.Entity
import androidx.room.Ignore
import androidx.room.PrimaryKey
import io.cosmostation.splash.secure.SplashCipherHelper
import io.cosmostation.splash.util.Prefs

@Entity(tableName = "wallet")
data class Wallet(
    @PrimaryKey(autoGenerate = true) val id: Long,
    var name: String,
    var address: String,
    val encryptedMnemonic: String
) {
    constructor(name: String, address: String, encryptedMnemonic: String) : this(0, name, address, encryptedMnemonic)

    @Ignore
    val mnemonic = SplashCipherHelper.decrypt(encryptedMnemonic, Prefs.pin)
}