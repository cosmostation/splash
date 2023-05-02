package io.cosmostation.splash.ui.staking

import android.os.Bundle
import androidx.activity.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityStakingObjectsBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.splash.ui.staking.stake.UnstakeSheet
import org.json.JSONArray
import org.json.JSONObject

class StakingObjectListActivity : ActionBarBaseActivity() {
    private lateinit var binding: ActivityStakingObjectsBinding
    private val viewModel: StakingViewModel by viewModels()
    private lateinit var adapter: StakingObjectAdapter

    override val titleResourceId: Int
        get() = R.string.staking_objects_title

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityStakingObjectsBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupRecyclerView()
        setupViewModels()
    }

    private fun setupRecyclerView() {
        adapter = StakingObjectAdapter(this) { unstake(it) }
        binding.recycler.layoutManager = LinearLayoutManager(this)
        binding.recycler.adapter = adapter
        adapter.notifyDataSetChanged()
    }

    private fun unstake(stakeObject: JSONObject) {
        UnstakeSheet(stakeObject).show(supportFragmentManager, UnstakeSheet::class.java.name)
    }

    override fun onResume() {
        super.onResume()
        viewModel.loadStakes()
    }

    private fun setupViewModels() {
        viewModel.stakeInfos.observe(this) {
            val stakeInfos = JSONArray(it)
            val stakeItems = JSONArray()
            for (i in 0 until stakeInfos.length()) {
                val stakeInfo = stakeInfos.getJSONObject(i)
                val stakeItemList = stakeInfo.getJSONArray("stakes")
                for (j in 0 until stakeItemList.length()) {
                    val stakeItem = stakeItemList.getJSONObject(j)
                    stakeItem.put("info", stakeInfo)
                    stakeItems.put(stakeItem)
                }
            }
            adapter.items = stakeItems
            adapter.notifyDataSetChanged()
        }

        viewModel.validatorInfos.observe(this) {
            val validatorMap = mutableMapOf<String, JSONObject>()
            for (i in 0 until it.length()) {
                val validator = it.getJSONObject(i)
                validatorMap[validator.getString("suiAddress")] = validator
            }
            adapter.validators = validatorMap
            adapter.notifyDataSetChanged()
        }
    }
}