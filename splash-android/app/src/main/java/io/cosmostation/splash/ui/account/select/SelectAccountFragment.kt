package io.cosmostation.splash.ui.account.select

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.databinding.FragmentSelectAccountBinding
import io.cosmostation.splash.ui.account.AccountViewModel
import io.cosmostation.splash.ui.account.setting.AccountSettingActivity
import io.cosmostation.splash.util.Prefs

class SelectAccountFragment : BottomSheetDialogFragment() {

    private lateinit var adapter: SelectAccountAdapter
    private lateinit var binding: FragmentSelectAccountBinding
    private val viewModel: AccountViewModel by viewModels()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentSelectAccountBinding.inflate(layoutInflater)

        setupViews()
        setupViewModels()
        viewModel.loadWallets()
        return binding.root
    }

    private fun setupViewModels() {
        viewModel.wallets.observe(this) {
            adapter.entities = it
            adapter.notifyDataSetChanged()
        }
    }

    private fun setupViews() {
        binding.settingBtn.setOnClickListener {
            startActivity(Intent(requireContext(), AccountSettingActivity::class.java))
            dismiss()
        }

        setupRecyclerView()
    }

    private fun setupRecyclerView() {
        adapter = SelectAccountAdapter(requireContext(), onSelect = selectAccount(), address = {
            SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.id ?: -1L
        })
        binding.recycler.layoutManager = LinearLayoutManager(activity)
        binding.recycler.adapter = adapter
    }

    private fun selectAccount(): (entity: Wallet) -> Unit = {
        if (SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.address != it.address) {
            Prefs.currentWalletId = it.id
            SplashWalletApp.instance.applicationViewModel.loadWallet()
        }
        dismiss()
    }
}