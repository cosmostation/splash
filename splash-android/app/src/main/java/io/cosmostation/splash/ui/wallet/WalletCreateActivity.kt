package io.cosmostation.splash.ui.wallet

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.recyclerview.widget.GridLayoutManager
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityWalletCreateBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.password.PinActivity
import io.cosmostation.splash.util.ExportUtils

class WalletCreateActivity : ActionBarBaseActivity() {
    private lateinit var binding: ActivityWalletCreateBinding
    private lateinit var adapter: MnemonicAdapter
    private val viewModel: WalletCreateViewModel by viewModels()

    override val titleResourceId: Int
        get() = R.string.add_wallet_intro_create

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWalletCreateBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        setupViewModels()
        viewModel.generateMnemonic()
    }

    private fun setupViewModels() {
        viewModel.mnemonic.observe(this) {
            adapter.words.clear()
            adapter.words.addAll(it.split(" "))
            adapter.notifyDataSetChanged()
        }

        viewModel.create.observe(this) {
            Toast.makeText(this, "Created!", Toast.LENGTH_LONG).show()
            finish()
        }
    }

    private fun setupViews() {
        val resultLauncher =
            registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
                if (result.resultCode == Activity.RESULT_OK) {
                    viewModel.mnemonic.value?.let { mnemonic ->
                        viewModel.createClick(
                            binding.name.text.toString(), mnemonic
                        )
                    }
                }
            }

        adapter = MnemonicAdapter(this)
        binding.recycler.layoutManager = GridLayoutManager(this, 3)
        binding.recycler.adapter = adapter
        binding.nextBtn.setOnClickListener {
            if (binding.name.text.isEmpty()) {
                Toast.makeText(this, "Empty !", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }
            resultLauncher.launch(Intent(this, PinActivity::class.java))
        }

        binding.copy.setOnClickListener {
            viewModel.mnemonic.value?.let { mnemonic ->
                ExportUtils.toClipboard(this, mnemonic)
                Toast.makeText(this, "Copied !", Toast.LENGTH_LONG).show()
            }
        }
    }
}