package io.cosmostation.splash.ui.staking.validator

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import io.cosmostation.splash.databinding.FragmentSelectValidatorSheetBinding
import org.json.JSONObject

class SelectValidatorFragment(val listener: ValidatorSelectListener) : BottomSheetDialogFragment() {

    private lateinit var adapter: SelectValidatorAdapter
    private lateinit var binding: FragmentSelectValidatorSheetBinding
    private val viewModel: SelectValidatorViewModel by viewModels()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentSelectValidatorSheetBinding.inflate(layoutInflater)

        setupViews()
        setupViewModels()
        viewModel.loadValidatorInfo()
        return binding.root
    }

    private fun setupViewModels() {
        viewModel.validatorInfos.observe(this) {
            adapter.entities = it
            adapter.notifyDataSetChanged()
        }
    }

    private fun setupViews() {
        setupRecyclerView()
    }

    private fun setupRecyclerView() {
        adapter = SelectValidatorAdapter(requireContext(), onSelect = selectAccount())
        binding.recycler.layoutManager = LinearLayoutManager(activity)
        binding.recycler.adapter = adapter
    }

    private fun selectAccount(): (entity: JSONObject) -> Unit = {
        listener.select(it)
        dismiss()
    }

    interface ValidatorSelectListener {
        fun select(validator: JSONObject)
    }
}