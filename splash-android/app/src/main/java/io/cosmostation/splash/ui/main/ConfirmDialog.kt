package io.cosmostation.splash.ui.main

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.DialogConfirmBinding

class ConfirmDialog : DialogFragment() {

    private var _binding: DialogConfirmBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = DialogConfirmBinding.inflate(layoutInflater, container, false)

        setUpClickAction()
        return binding.root
    }

    private fun setUpClickAction() {
        binding.confirmBtn.setOnClickListener {
            dismiss()
        }

        binding.linkBtn.setOnClickListener {
            startActivity(
                Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse("market://details?id=" + "wannabit.io.cosmostaion")
                )
            )
        }
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }
}