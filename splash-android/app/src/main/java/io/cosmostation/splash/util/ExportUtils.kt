package io.cosmostation.splash.util

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.graphics.Bitmap
import com.google.zxing.BarcodeFormat
import com.google.zxing.MultiFormatWriter
import com.google.zxing.WriterException
import com.journeyapps.barcodescanner.BarcodeEncoder


object ExportUtils {
    fun toQR(text: String?): Bitmap? {
        return try {
            val bitMatrix = MultiFormatWriter().encode(text, BarcodeFormat.QR_CODE, 400, 400)
            BarcodeEncoder().createBitmap(bitMatrix)
        } catch (e: WriterException) {
            null
        }
    }

    fun toClipboard(context: Context?, target: String?) {
        val clipboard = context?.getSystemService(Context.CLIPBOARD_SERVICE) as? ClipboardManager
        val clip = ClipData.newPlainText("clipboard", target)
        clipboard?.setPrimaryClip(clip)
    }
}