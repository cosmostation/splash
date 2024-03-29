package io.cosmostation.splash.ui.wallet

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityImportPrivateKeyBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.password.PinActivity
import io.cosmostation.suikotlin.SuiClient
import net.i2p.crypto.eddsa.Utils

class ImportPrivateKeyActivity : ActionBarBaseActivity() {
    private lateinit var binding: ActivityImportPrivateKeyBinding
    private val viewModel: ImportPrivateKeyViewModel by viewModels()

    override val titleResourceId: Int
        get() = R.string.import_private_key

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityImportPrivateKeyBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        setupViewModels()
    }

    private fun setupViewModels() {
        viewModel.create.observe(this) {
            Toast.makeText(this, "Imported !", Toast.LENGTH_LONG).show()
            finish()
        }

    }

    private fun setupViews() {
        val resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                viewModel.createByPrivateKey(binding.name.text.toString(), binding.privateKey.text.toString())
            }
        }

        binding.nextBtn.setOnClickListener {
            if (binding.name.text?.isEmpty() == true || binding.privateKey.text?.isEmpty() == true) {
                Toast.makeText(this, "Empty private key", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }

            binding.privateKey.text?.toString()?.let {
                try {
                    val keyPair = SuiClient.instance.getKeyPairByPrivateKey(it)
                    binding.privateKey.setText("0x${Utils.bytesToHex(keyPair.privateKey.seed)}")
                } catch (e: Exception) {
                    Toast.makeText(this, "Not valid private key !", Toast.LENGTH_LONG).show()
                    return@setOnClickListener
                }
            }

            resultLauncher.launch(Intent(this, PinActivity::class.java))
        }
    }
}