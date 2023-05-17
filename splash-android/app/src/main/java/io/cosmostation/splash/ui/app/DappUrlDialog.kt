package io.cosmostation.splash.ui.app

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import androidx.fragment.app.DialogFragment
import io.cosmostation.splash.databinding.FragmentDappUrlBinding

class DappUrlDialog(val url: String, private val listener: UrlListener) : DialogFragment() {
    private var _binding: FragmentDappUrlBinding? = null
    private val binding get() = _binding!!

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setStyle(STYLE_NORMAL, android.R.style.Theme_Black_NoTitleBar_Fullscreen)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentDappUrlBinding.inflate(inflater, container, false)
        settingViews()
        binding.url.setText(url)
        return binding.root
    }

    override fun onStart() {
        super.onStart()
        binding.url.clearFocus()
        binding.url.requestFocus()
        binding.url.postDelayed({
            val imm = context?.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            imm.showSoftInput(binding.url, 0)
        }, 250)
    }

    private fun settingViews() {
        dialog?.window?.setBackgroundDrawableResource(android.R.color.transparent)
        binding.dimmedWrap.setOnClickListener { dismiss() }
        binding.url.setOnEditorActionListener { v, actionId, event ->
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                listener.input(binding.url.text.toString())
                dismiss()
            }
            false
        }
    }

    interface UrlListener {
        fun input(url: String)
    }
}