package io.cosmostation.splash.ui.account

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.viewModels
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.databinding.FragmentDeleteAccountBinding
import io.cosmostation.splash.ui.password.PinActivity

class DeleteAccountDialog(private val entity: Wallet) : BottomSheetDialogFragment() {

    private lateinit var binding: FragmentDeleteAccountBinding
    private val viewModel: AccountViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        binding = FragmentDeleteAccountBinding.inflate(layoutInflater)
        setupViews()

        return binding.root
    }

    private fun setupViews() {
        val resultLauncher =
            registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
                if (result.resultCode == Activity.RESULT_OK) {
                    viewModel.deleteWallet(entity)
                    activity?.recreate()
                    dismiss()
                }
            }
        binding.address.setText(entity.address)
        binding.confirmBtn.setOnClickListener {
            if (SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.id == entity.id) {
                context?.let {
                    Toast.makeText(it, getString(R.string.current_account_delete_error), Toast.LENGTH_LONG).show()
                }
                dismiss()
                return@setOnClickListener
            }
            resultLauncher.launch(Intent(activity, PinActivity::class.java))
        }
    }
}