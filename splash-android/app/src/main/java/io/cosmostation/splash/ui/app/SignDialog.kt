package io.cosmostation.splash.ui.app

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import io.cosmostation.splash.databinding.FragmentSignBinding
import org.json.JSONObject

class SignDialog(
    private val method: String, private val params: JSONObject, private val listener: SignListener
) : BottomSheetDialogFragment() {
    private lateinit var binding: FragmentSignBinding

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        binding = FragmentSignBinding.inflate(layoutInflater)
        setupViews()
        return binding.root
    }

    private fun setupViews() {
        dialog?.setCancelable(false)
        dialog?.setCanceledOnTouchOutside(false)
        binding.method.text = method
        binding.message.text = params.toString()
        binding.confirmBtn.setOnClickListener {
            listener.confirm()
            dismiss()
        }
        binding.cancelBtn.setOnClickListener {
            listener.cancel()
            dismiss()
        }
    }

    interface SignListener {
        fun confirm()
        fun cancel()
    }
}