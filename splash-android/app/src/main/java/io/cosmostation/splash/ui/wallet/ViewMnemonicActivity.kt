package io.cosmostation.splash.ui.wallet

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.recyclerview.widget.GridLayoutManager
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityViewMnemonicBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.password.PinActivity
import io.cosmostation.splash.util.ExportUtils

class ViewMnemonicActivity : ActionBarBaseActivity() {
    companion object {
        const val INTENT_MNEMONIC_KEY = "mnemonic"
    }

    private lateinit var binding: ActivityViewMnemonicBinding
    private lateinit var adapter: MnemonicAdapter

    override val titleResourceId: Int
        get() = R.string.view_mnemonics

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityViewMnemonicBinding.inflate(layoutInflater)
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
        val optionalMnemonic = intent.getStringExtra(INTENT_MNEMONIC_KEY)
        adapter = MnemonicAdapter(this)
        binding.recycler.layoutManager = GridLayoutManager(this, 3)
        binding.recycler.adapter = adapter
        optionalMnemonic?.let { mnemonic ->
            adapter.words.clear()
            adapter.words.addAll(mnemonic.split(" "))
            adapter.notifyDataSetChanged()
        } ?: run {
            Toast.makeText(this, "Error !", Toast.LENGTH_LONG).show()
            finish()
        }
        binding.copy.setOnClickListener {
            optionalMnemonic?.let { mnemonic ->
                ExportUtils.toClipboard(this, mnemonic)
                Toast.makeText(this, "Copied !", Toast.LENGTH_LONG).show()
            }
        }
    }

}