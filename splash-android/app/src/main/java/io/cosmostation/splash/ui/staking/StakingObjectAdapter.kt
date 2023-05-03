package io.cosmostation.splash.ui.staking

import android.content.Context
import android.net.Uri
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.google.common.collect.Maps
import io.cosmostation.splash.databinding.ItemStakingObjectBinding
import io.cosmostation.splash.util.formatDecimal
import org.json.JSONArray
import org.json.JSONObject
import java.math.BigInteger

class StakingObjectAdapter(
    private val context: Context, var items: JSONArray = JSONArray(), var validators: Map<String, JSONObject> = Maps.newHashMap(), val action: (suiObject: JSONObject) -> Unit
) : RecyclerView.Adapter<StakingObjectViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StakingObjectViewHolder {
        val binding = ItemStakingObjectBinding.inflate(LayoutInflater.from(context), parent, false)
        return StakingObjectViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: StakingObjectViewHolder, position: Int) {
        val item = items.getJSONObject(position)
        val validatorAddress = item.getJSONObject("info").getString("validatorAddress")
        viewHolder.binding.objectId.text = item.getString("stakedSuiId")
        viewHolder.binding.logo.setImageURI(Uri.parse(validators[validatorAddress]?.getString("imageUrl")))
        viewHolder.binding.validator.text = validators[validatorAddress]?.getString("name")
        viewHolder.binding.stakeAmount.text = BigInteger(item.getString("principal")).formatDecimal(trim = 9)
        if (item.has("estimatedReward")) {
            viewHolder.binding.earned.text = BigInteger(item.getString("estimatedReward")).formatDecimal(trim = 9)
        } else {
            viewHolder.binding.earned.text = "0.0"
        }
        viewHolder.binding.epoch.text = "Epoch #${item.getString("stakeActiveEpoch")} (${item.getString("status")})"
        viewHolder.binding.wrap.setOnClickListener {
            if ("pending".equals(item.getString("status"), true)) {
                Toast.makeText(context, "Cannot unstake pending object !", Toast.LENGTH_LONG).show()
            } else {
                action(item)
            }
        }
    }

    override fun getItemCount(): Int {
        return items.length()
    }
}