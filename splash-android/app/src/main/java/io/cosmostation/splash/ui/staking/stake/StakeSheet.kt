package io.cosmostation.splash.ui.staking.stake

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
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.FragmentStakingSheetBinding
import io.cosmostation.splash.ui.password.PinActivity
import io.cosmostation.splash.ui.transaction.TransactionResultActivity
import org.json.JSONObject

class StakeSheet(val amount: String, val gas: String, private val validatorInfo: JSONObject) : BottomSheetDialogFragment() {

    private lateinit var binding: FragmentStakingSheetBinding
    private val viewModel: StakeViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        binding = FragmentStakingSheetBinding.inflate(layoutInflater)
        setupViews()
        setupViewModel()
        return binding.root
    }

    private fun setupViewModel() {
        viewModel.error.observe(viewLifecycleOwner) {
            Toast.makeText(context, "Error !", Toast.LENGTH_LONG).show()
            activity?.recreate()
            dismiss()
        }

        viewModel.result.observe(viewLifecycleOwner) {
            activity?.finish()
            startActivity(Intent(context, TransactionResultActivity::class.java).putExtra("executeResult", it))
            dismiss()
            SplashWalletApp.instance.applicationViewModel.loadAllData()
        }
    }

    private fun setupViews() {
        binding.amount.text = amount
        binding.validator.text = validatorInfo.getString("name")
        binding.gas.text = gas
        val resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                viewModel.stake(validatorInfo, amount)
            }
        }
        binding.confirmBtn.setOnClickListener {
            resultLauncher.launch(Intent(activity, PinActivity::class.java))
        }
    }
}