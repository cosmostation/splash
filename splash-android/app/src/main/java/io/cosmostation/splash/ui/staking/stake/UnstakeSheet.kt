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
import io.cosmostation.splash.databinding.FragmentUnstakingSheetBinding
import io.cosmostation.splash.ui.common.LoadingFragment
import io.cosmostation.splash.ui.password.PinActivity
import io.cosmostation.splash.ui.transaction.TransactionResultActivity
import io.cosmostation.splash.util.DecimalUtils
import org.json.JSONObject
import java.math.BigInteger

class UnstakeSheet(private val item: JSONObject) : BottomSheetDialogFragment() {

    private lateinit var binding: FragmentUnstakingSheetBinding
    private val viewModel: StakeViewModel by viewModels()

    var dialog: LoadingFragment = LoadingFragment()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentUnstakingSheetBinding.inflate(layoutInflater)
        setupViews()
        setupViewModel()
        return binding.root
    }

    private fun setupViewModel() {
        viewModel.error.observe(viewLifecycleOwner) {
            dialog.dismiss()
            Toast.makeText(context, it, Toast.LENGTH_LONG).show()
            activity?.recreate()
            dismiss()
        }

        viewModel.result.observe(viewLifecycleOwner) {
            dialog.dismiss()
            activity?.recreate()
            startActivity(Intent(context, TransactionResultActivity::class.java).putExtra("executeResult", it))
            dismiss()
            SplashWalletApp.instance.applicationViewModel.loadAllData()
        }
    }

    private fun setupViews() {
        val resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                activity?.supportFragmentManager?.let { dialog.show(it, LoadingFragment::class.java.name) }
                viewModel.unstake(item)
            }
        }

        binding.gas.text = "0.7"
        binding.objectId.text = item.getString("stakedSuiId")
        binding.total.text = DecimalUtils.toString((BigInteger(item.getString("principal")) + BigInteger(item.getString("estimatedReward"))).toLong())
        binding.confirmBtn.setOnClickListener {
            resultLauncher.launch(Intent(activity, PinActivity::class.java))
        }
    }
}