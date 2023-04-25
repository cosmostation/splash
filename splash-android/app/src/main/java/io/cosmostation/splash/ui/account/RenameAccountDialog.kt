package io.cosmostation.splash.ui.account

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.viewModels
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import io.cosmostation.splash.R
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.databinding.FragmentRenameAccountBinding

class RenameAccountDialog(private val entity: Wallet) : BottomSheetDialogFragment() {
    private lateinit var binding: FragmentRenameAccountBinding
    private val viewModel: AccountViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        binding = FragmentRenameAccountBinding.inflate(layoutInflater)
        setupViews()
        return binding.root
    }

    private fun setupViews() {
        binding.name.setText(entity.name)
        binding.confirmBtn.setOnClickListener {
            if (binding.name.text.equals(entity.name)) {
                dismiss()
            } else if (binding.name.text.isBlank()) {
                Toast.makeText(context, getString(R.string.rename_empty), Toast.LENGTH_LONG).show()
            } else {
                entity.name = binding.name.text.toString()
                viewModel.updateWallet(entity)
                activity?.recreate()
                dismiss()
            }
        }
    }
}