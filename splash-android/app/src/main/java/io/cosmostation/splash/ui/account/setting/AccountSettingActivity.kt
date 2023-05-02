package io.cosmostation.splash.ui.account.setting

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.activity.viewModels
import androidx.appcompat.widget.PopupMenu
import androidx.recyclerview.widget.LinearLayoutManager
import io.cosmostation.splash.R
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.databinding.ActivityAccountSettingBinding
import io.cosmostation.splash.ui.account.AccountViewModel
import io.cosmostation.splash.ui.account.DeleteAccountDialog
import io.cosmostation.splash.ui.account.RenameAccountDialog
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.wallet.ViewMnemonicActivity
import io.cosmostation.splash.ui.wallet.WalletAddIntroFragment

class AccountSettingActivity : ActionBarBaseActivity() {
    private lateinit var adapter: AccountSettingAdapter
    private lateinit var binding: ActivityAccountSettingBinding
    private val viewModel: AccountViewModel by viewModels()

    override val titleResourceId: Int
        get() = R.string.account

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAccountSettingBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        setupViewModels()
    }

    override fun onResume() {
        super.onResume()
        viewModel.loadWallets()
    }

    private fun setupViewModels() {
        viewModel.wallets.observe(this) {
            adapter.entities = it
            adapter.notifyDataSetChanged()
        }
    }

    private fun setupViews() {
        setupRecyclerView()
        binding.createBtn.setOnClickListener {
            WalletAddIntroFragment().show(supportFragmentManager, WalletAddIntroFragment::class.java.name)
        }
    }

    private fun setupRecyclerView() {
        adapter = AccountSettingAdapter(this, onClickMore = selectMoreMenu())
        binding.recycler.layoutManager = LinearLayoutManager(this)
        binding.recycler.adapter = adapter
    }

    private fun selectMoreMenu(): (view: View, entity: Wallet) -> Unit = { view, item ->
        val popup = PopupMenu(this, view)
        popup.inflate(R.menu.account_setting_menu)
        popup.setOnMenuItemClickListener {
            when (it.itemId) {
                R.id.rename -> RenameAccountDialog(item).show(
                    supportFragmentManager, RenameAccountDialog::class.java.name
                )
                R.id.delete -> DeleteAccountDialog(item).show(
                    supportFragmentManager, DeleteAccountDialog::class.java.name
                )
                R.id.view -> startActivity(
                    Intent(this, ViewMnemonicActivity::class.java).putExtra(ViewMnemonicActivity.INTENT_MNEMONIC_KEY, item.mnemonic)
                )
            }
            true
        }
        popup.show()
    }
}