package io.cosmostation.splash.ui.app

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import io.cosmostation.splash.databinding.FragmentAppBinding
import io.cosmostation.splash.util.visibleOrGone

class AppFragment : Fragment() {
    private lateinit var adapter: AppAdapter
    private lateinit var binding: FragmentAppBinding
    private val viewModel: AppViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        binding = FragmentAppBinding.inflate(layoutInflater, container, false)
        setupRecyclerView()
        return binding.root
    }

    private fun setupRecyclerView() {
        adapter = AppAdapter(requireContext())
        binding.recycler.layoutManager = LinearLayoutManager(activity)
        binding.recycler.adapter = adapter
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupLiveData()
        viewModel.loadApps()
    }

    private fun setupLiveData() {
        viewModel.apps.observe(viewLifecycleOwner) {
            adapter.apps.clear()
            binding.empty.visibleOrGone(it.isEmpty())
            binding.recycler.visibleOrGone(it.isNotEmpty())
            adapter.apps.addAll(it)
            adapter.notifyDataSetChanged()
        }
    }
}