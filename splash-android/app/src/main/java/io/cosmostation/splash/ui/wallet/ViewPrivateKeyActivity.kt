package io.cosmostation.splash.ui.wallet

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityViewPrivateKeyBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.password.PinActivity
import io.cosmostation.splash.util.ExportUtils

class ViewPrivateKeyActivity : ActionBarBaseActivity() {
    companion object {
        const val INTENT_PRIVATE_KEY_KEY = "privatekey"
    }

    private lateinit var binding: ActivityViewPrivateKeyBinding

    override val titleResourceId: Int
        get() = R.string.view_private_key

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityViewPrivateKeyBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        checkPassword()
    }

    private fun checkPassword() {
        val resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode != RESULT_OK) {
                finish()
            }
        }
        resultLauncher.launch(Intent(this, PinActivity::class.java))
    }

    private fun setupViews() {
        val optionalPrivateKey = intent.getStringExtra(INTENT_PRIVATE_KEY_KEY)
        optionalPrivateKey?.let { privateKey ->
            binding.privateKey.text = privateKey
        } ?: run {
            Toast.makeText(this, "Error !", Toast.LENGTH_LONG).show()
            finish()
        }
        binding.copy.setOnClickListener {
            optionalPrivateKey?.let { privateKey ->
                ExportUtils.toClipboard(this, privateKey)
                Toast.makeText(this, "Copied !", Toast.LENGTH_LONG).show()
            }
        }
    }

}