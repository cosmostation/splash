package io.cosmostation.splash.ui.staking

import android.content.Intent
import android.os.Bundle
import androidx.activity.viewModels
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityStakingBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.util.formatDecimal
import io.cosmostation.splash.util.visibleOrGone
import org.json.JSONArray
import java.math.BigInteger
import java.util.*

class StakingActivity : ActionBarBaseActivity() {
    private lateinit var binding: ActivityStakingBinding
    private val viewModel: StakingViewModel by viewModels()
    private val timer: Timer = Timer()

    override val titleResourceId: Int
        get() = R.string.staking_title

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityStakingBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        setupViewModels()
    }

    private fun setupViews() {
        binding.stakeBtn.setOnClickListener { startActivity(Intent(this, StakingStakeActivity::class.java)) }
        binding.unstakeBtn.setOnClickListener { startActivity(Intent(this, StakingObjectListActivity::class.java)) }
    }

    override fun onResume() {
        super.onResume()
        viewModel.loadInfo()
        viewModel.loadStakes()
    }

    private fun setupViewModels() {
        viewModel.epoch.observe(this) {
            binding.epoch.text = "#$it"
            binding.guideCurrent.text = "If you have started staking, it will remain in a 'pending' state until the current epoch (#${it}) ends."
            binding.guideNext.text = "At the end of the next epoch (#${it + 1}), rewards will be distributed. Each subsequent epoch will be repeated."
        }

        viewModel.epochEndMs.observe(this) {
            timer.schedule(object : TimerTask() {
                override fun run() {
                    runOnUiThread {
                        val remain = (it - Date().time) / 1000
                        val hour = remain / 3600
                        val minute = remain % 3600 / 60
                        val second = remain % 60
                        binding.timer.text = String.format("%02d:%02d:%02d", hour, minute, second)
                    }
                }
            }, 0, 1000)
        }

        viewModel.totalBalance.observe(this) {
            binding.available.text = it.formatDecimal()
        }

        viewModel.stakeInfos.observe(this) {
            val stakeInfos = JSONArray(it)
            binding.statusWrap.visibleOrGone(stakeInfos.length() > 0)
            var reward = BigInteger.ZERO
            var principal = BigInteger.ZERO
            for (i in 0 until stakeInfos.length()) {
                val stakeInfo = stakeInfos.getJSONObject(i)
                val stakeItemList = stakeInfo.getJSONArray("stakes")
                for (j in 0 until stakeItemList.length()) {
                    val stakeItem = stakeItemList.getJSONObject(j)
                    if (stakeItem.has("principal")) {
                        principal += BigInteger(stakeItem.getString("principal"))
                    }
                    if (stakeItem.has("estimatedReward")) {
                        reward += BigInteger(stakeItem.getString("estimatedReward"))
                    }
                }
            }
            binding.stakeTotal.text = principal.add(reward).formatDecimal(trim = 9)
            binding.stakeStaked.text = principal.formatDecimal(trim = 9)
            binding.stakeEarned.text = reward.formatDecimal(trim = 9)
        }
    }
}