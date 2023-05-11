package io.cosmostation.splash.ui.wallet

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityWalletImportBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.password.PinActivity
import org.bitcoinj.crypto.MnemonicCode

class ImportMnemonicActivity : ActionBarBaseActivity() {
    private lateinit var binding: ActivityWalletImportBinding
    private val viewModel: WalletCreateViewModel by viewModels()

    override val titleResourceId: Int
        get() = R.string.add_wallet_intro_import

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWalletImportBinding.inflate(layoutInflater)
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
                viewModel.createByMnemonic(
                    binding.name.text.toString(), binding.mnemonic.text.toString()
                )
            }
        }

        binding.nextBtn.setOnClickListener {
            if (binding.name.text?.isEmpty() == true || binding.mnemonic.text?.isEmpty() == true) {
                Toast.makeText(this, "Empty mnemonic", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }

            binding.mnemonic.text?.toString()?.let {
                try {
                    MnemonicCode.INSTANCE.check(it.split(" "))
                } catch (e: Exception) {
                    Toast.makeText(this, "Not valid Mnemonic", Toast.LENGTH_LONG).show()
                    return@setOnClickListener
                }
            }

            resultLauncher.launch(Intent(this, PinActivity::class.java))
        }
    }
}