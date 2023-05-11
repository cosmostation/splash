package io.cosmostation.splash.database

import androidx.room.Entity
import androidx.room.Ignore
import androidx.room.PrimaryKey
import io.cosmostation.splash.secure.SplashCipherHelper
import io.cosmostation.splash.util.Prefs
import io.cosmostation.suikotlin.SuiClient
import net.i2p.crypto.eddsa.Utils

@Entity(tableName = "wallet")
data class Wallet(@PrimaryKey(autoGenerate = true) val id: Long, var name: String, var address: String, val encryptedMnemonic: String? = null, val encryptedPrivateKey: String? = null) {

    @delegate:Ignore
    val mnemonic: String? by lazy {
        SplashCipherHelper.decrypt(encryptedMnemonic, Prefs.pin)
    }

    @delegate:Ignore
    val privateKey: String? by lazy {
        encryptedPrivateKey?.let {
            SplashCipherHelper.decrypt(encryptedPrivateKey, Prefs.pin)
        } ?: run {
            val mnemonic = SplashCipherHelper.decrypt(encryptedMnemonic, Prefs.pin)
            mnemonic?.let {
                val keyPair = SuiClient.instance.getKeyPair(mnemonic)
                "0x${Utils.bytesToHex(keyPair.privateKey.seed)}"
            }
        }
    }

    companion object {
        fun createByMnemonic(name: String, mnemonic: String): Wallet {
            return Wallet(0, name, SuiClient.instance.getAddress(mnemonic), encryptedMnemonic = SplashCipherHelper.encrypt(mnemonic, Prefs.pin))
        }

        fun createByPrivateKey(name: String, privateKey: String): Wallet {
            val keyPair = SuiClient.instance.getKeyPairByPrivateKey(privateKey)
            return Wallet(0, name, SuiClient.instance.getAddress(keyPair), encryptedPrivateKey = SplashCipherHelper.encrypt(privateKey, Prefs.pin))
        }
    }
}