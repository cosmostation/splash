package io.cosmostation.splash.ui.wallet

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import io.cosmostation.splash.databinding.FragmentIntroAddWalletBinding

class WalletAddIntroFragment : BottomSheetDialogFragment() {
    private lateinit var binding: FragmentIntroAddWalletBinding

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        binding = FragmentIntroAddWalletBinding.inflate(layoutInflater)

        setupViews()
        return binding.root
    }

    private fun setupViews() {
        binding.createMnemonic.setOnClickListener {
            activity?.let {
                startActivity(Intent(it, WalletCreateActivity::class.java))
                it.finish()
            }
        }
        binding.importMnemonic.setOnClickListener {
            activity?.let {
                startActivity(Intent(it, ImportMnemonicActivity::class.java))
                it.finish()
            }
        }
        binding.importPrivateKey.setOnClickListener {
            activity?.let {
                startActivity(Intent(it, ImportMnemonicActivity::class.java))
                it.finish()
            }
        }
    }

}