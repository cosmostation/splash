package io.cosmostation.splash.ui.wallet

import android.os.Bundle
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityWalletAddIntroBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity

class WalletAddIntroActivity : ActionBarBaseActivity() {
    private lateinit var binding: ActivityWalletAddIntroBinding

    companion object {
        const val TYPE_KEY = "type"
        const val TYPE_VALUE_SETTING = "setting"
    }

    override val titleResourceId: Int
        get() = R.string.create_account

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWalletAddIntroBinding.inflate(layoutInflater)
        setupTheme()
        setContentView(binding.root)
        setupViews()
    }

    private fun setupTheme() {
        if (intent.getStringExtra(TYPE_KEY) == TYPE_VALUE_SETTING) {
            setTheme(R.style.ActionBarAppTheme)
        } else {
            setTheme(R.style.AppTheme)
            supportActionBar?.hide()
        }
    }

    private fun setupViews() {
        binding.importBtn.setOnClickListener {
            WalletAddIntroFragment().show(supportFragmentManager, WalletAddIntroFragment::class.java.name)
        }
    }
}
