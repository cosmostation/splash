package io.cosmostation.splash.ui.staking

import android.os.Bundle
import android.widget.Toast
import androidx.activity.viewModels
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityStakingStakeBinding
import io.cosmostation.splash.ui.account.DeleteAccountDialog
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.staking.stake.StakeSheet
import io.cosmostation.splash.ui.staking.stake.UnstakeSheet
import io.cosmostation.splash.ui.staking.validator.SelectValidatorFragment
import io.cosmostation.splash.util.GasUtils
import io.cosmostation.splash.util.addDecimalCheckListener
import io.cosmostation.splash.util.formatDecimal
import io.cosmostation.splash.util.formatGasDecimal
import org.json.JSONArray
import org.json.JSONObject
import java.math.BigDecimal
import java.math.BigInteger

class StakingStakeActivity : ActionBarBaseActivity() {
    private lateinit var binding: ActivityStakingStakeBinding
    private val viewModel: StakingStakeViewModel by viewModels()

    var currentValidator: JSONObject? = null
        set(value) {
            field = value
            updateView()
        }

    override val titleResourceId: Int
        get() = R.string.staking

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityStakingStakeBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        setupViewModels()
    }

    override fun onResume() {
        super.onResume()
        viewModel.loadInfo()
        viewModel.loadStakes()
    }

    private fun setupViewModels() {
        viewModel.totalBalance.observe(this) {
            binding.available.text = BigInteger(it).minus(GasUtils.getStakeGas()).formatDecimal()
        }

        viewModel.epoch.observe(this) {
            binding.startEarning.text = "Epoch #${it + 1}"
        }

        viewModel.validators.observe(this) {
            if (currentValidator == null) {
                currentValidator = it.getJSONObject(0)
                for (i in 0 until it.length()) {
                    if (it.getJSONObject(i).getString("name") == "Cosmostation") {
                        currentValidator = it.getJSONObject(i)
                    }
                }
            }
        }

        viewModel.stakeInfos.observe(this) {
            updateStakeInfo(it)
        }
    }

    private fun updateStakeInfo(info: String) {
        val stakeInfos = JSONArray(info)
        var myStake = BigInteger.ZERO
        for (i in 0 until stakeInfos.length()) {
            val stakeInfo = stakeInfos.getJSONObject(i)
            if (stakeInfo.getString("validatorAddress") == currentValidator?.getString("suiAddress")) {
                val stakeItemList = stakeInfo.getJSONArray("stakes")
                for (j in 0 until stakeItemList.length()) {
                    val stakeItem = stakeItemList.getJSONObject(j)
                    myStake += BigInteger(stakeItem.getString("principal"))
                }
            }
        }
        binding.yourStaked.text = myStake.formatDecimal()
    }

    private fun updateView() {
        currentValidator?.let {
            binding.logo.setImageURI(it.getString("imageUrl"))
            binding.name.text = it.getString("name")
            binding.currentStaked.text = BigInteger(it.getString("stakingPoolSuiBalance")).formatDecimal()
            binding.commission.text = "${it.getString("commissionRate").toDouble() * 0.01}%"
            viewModel.stakeInfos.value?.let { it1 -> updateStakeInfo(it1) }
        }
    }

    private fun setupViews() {
        binding.nextBtn.setOnClickListener {
            if (binding.amount.text?.isEmpty() == true || BigDecimal(binding.amount.text.toString()) <= BigDecimal(0)) {
                Toast.makeText(this, "Empty amount", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }
            if (BigDecimal(binding.amount.text.toString()) > BigDecimal(binding.available.text.toString())) {
                Toast.makeText(this, "Not enough amount", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }
            currentValidator?.let { it1 -> StakeSheet(binding.amount.text.toString(), binding.gas.text.toString(), it1).show(supportFragmentManager, UnstakeSheet::class.java.name) }
        }
        binding.gas.text = GasUtils.getStakeGas().formatGasDecimal()
        binding.validatorWrap.setOnClickListener {
            SelectValidatorFragment(object : SelectValidatorFragment.ValidatorSelectListener {
                override fun select(validator: JSONObject) {
                    currentValidator = validator
                }
            }).show(supportFragmentManager, DeleteAccountDialog::class.java.name)
        }
        binding.amount.addDecimalCheckListener({ binding.available.text.toString() }, 9)
    }
}