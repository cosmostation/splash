package io.cosmostation.splash.ui.network

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.FragmentSelectNetworkBinding
import io.cosmostation.splash.util.Prefs
import io.cosmostation.suikotlin.SuiClient

class SelectNetworkFragment : BottomSheetDialogFragment() {
    private lateinit var adapter: SelectNetworkAdapter
    private lateinit var binding: FragmentSelectNetworkBinding


    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentSelectNetworkBinding.inflate(layoutInflater)
        setupRecyclerView()
        return binding.root
    }

    private fun setupRecyclerView() {
        adapter = SelectNetworkAdapter(requireContext(), SplashConstants.networks.map { it.key }.toList(), selectNetwork())
        binding.recycler.layoutManager = LinearLayoutManager(activity)
        binding.recycler.adapter = adapter
        adapter.notifyDataSetChanged()
    }

    private fun selectNetwork(): (network: String) -> Unit = {
        SplashConstants.networks[it]?.let { network ->
            if (Prefs.network != network.name) {
                Prefs.network = it
                SuiClient.configure(network)
                SplashWalletApp.instance.applicationViewModel.loadAllData()
                activity?.recreate()
            }
            dismiss()
        }
    }
}