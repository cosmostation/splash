package io.cosmostation.splash.ui.activity

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.FragmentActivityBinding
import io.cosmostation.splash.util.visibleOrGone

class ActivityFragment : Fragment() {
    private lateinit var adapter: ActivityAdapter
    private lateinit var binding: FragmentActivityBinding

    private val viewModel: ActivityViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        binding = FragmentActivityBinding.inflate(layoutInflater, container, false)
        setupRecyclerView()
        setupLiveData()

        return binding.root
    }

    private fun setupRecyclerView() {
        adapter = ActivityAdapter(requireContext())
        binding.recycler.layoutManager = LinearLayoutManager(activity)
        binding.recycler.adapter = adapter
    }

    override fun onResume() {
        super.onResume()
        SplashWalletApp.instance.applicationViewModel.allTransactionsLiveData.value?.let { transactions ->
            viewModel.loadActivities(transactions)
        } ?: run {
            SplashWalletApp.instance.applicationViewModel.loadTransactions()
        }
    }

    private fun setupLiveData() {
        SplashWalletApp.instance.applicationViewModel.allTransactionsLiveData.observe(
            viewLifecycleOwner
        ) { item ->
            item?.let { viewModel.loadActivities(it) }
        }
        viewModel.activities.observe(viewLifecycleOwner) {
            binding.empty.visibleOrGone(it.isEmpty())
            binding.recycler.visibleOrGone(it.isNotEmpty())
            adapter.transactions = it
            adapter.notifyDataSetChanged()
        }
    }
}
