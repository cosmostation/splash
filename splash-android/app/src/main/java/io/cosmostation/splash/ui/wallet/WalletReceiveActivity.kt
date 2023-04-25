package io.cosmostation.splash.ui.wallet

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityWalletReceiveBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.util.ExportUtils

class WalletReceiveActivity : ActionBarBaseActivity() {
    companion object {
        const val INTENT_ADDRESS_KEY = "address"
    }

    private lateinit var binding: ActivityWalletReceiveBinding

    override val titleResourceId: Int
        get() = R.string.receive

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWalletReceiveBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
    }

    private fun setupViews() {
        val address = intent.getStringExtra(INTENT_ADDRESS_KEY)
        binding.address.text = address
        binding.qrcode.setImageBitmap(ExportUtils.toQR(address))
        binding.shareBtn.setOnClickListener {
            Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_TEXT, address)
                type = "text/plain"
                val shareIntent = Intent.createChooser(this, null)
                startActivity(shareIntent)
            }
        }
        binding.addressCopy.setOnClickListener {
            ExportUtils.toClipboard(this, address)
            Toast.makeText(this, "Copied !", Toast.LENGTH_LONG).show()
        }
    }
}