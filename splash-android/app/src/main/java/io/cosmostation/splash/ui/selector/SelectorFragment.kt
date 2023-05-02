package io.cosmostation.splash.ui.selector

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import io.cosmostation.splash.databinding.FragmentSelectorBinding

class SelectorFragment(private val title: String, private val items: List<String>, private val current: String, private val listener: (item: String) -> Unit) : BottomSheetDialogFragment() {
    private lateinit var adapter: SelectorAdapter
    private lateinit var binding: FragmentSelectorBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentSelectorBinding.inflate(layoutInflater)
        setupViews()
        setupRecyclerView()
        return binding.root
    }

    private fun setupViews() {
        binding.title.text = title
    }

    private fun setupRecyclerView() {
        adapter = SelectorAdapter(requireContext(), items, current) {
            dismiss()
            listener(it)
        }
        binding.recycler.layoutManager = LinearLayoutManager(activity)
        binding.recycler.adapter = adapter
        adapter.notifyDataSetChanged()
    }
}