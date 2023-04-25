package io.cosmostation.splash.secure

import org.bouncycastle.util.encoders.Base64
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

object SplashCipherHelper {
    fun encrypt(input: String, key: String): String {
        val aesEncrypted = aesEncrypt(input, key)
        return CipherHelper.encrypt(aesEncrypted)
    }

    fun decrypt(input: String, key: String): String {
        val keystoreDecrypted = CipherHelper.decrypt(input)
        return aesDecrypt(keystoreDecrypted, key)
    }

    private fun aesEncrypt(input: String, key: String): String {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        val keySpec = SecretKeySpec(key.toByteArray().copyOf(16), "AES")
        cipher.init(Cipher.ENCRYPT_MODE, keySpec, IvParameterSpec(key.toByteArray().copyOf(16)))
        val result = cipher.doFinal(input.toByteArray())
        return String(Base64.encode(result))
    }

    private fun aesDecrypt(input: String, key: String): String {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        val keySpec = SecretKeySpec(key.toByteArray().copyOf(16), "AES")
        cipher.init(Cipher.DECRYPT_MODE, keySpec, IvParameterSpec(key.toByteArray().copyOf(16)))
        val decrypt = cipher.doFinal(Base64.decode(input))
        return String(decrypt)
    }
}