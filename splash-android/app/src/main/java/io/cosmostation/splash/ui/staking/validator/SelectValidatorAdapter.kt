package io.cosmostation.splash.ui.staking.validator

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.databinding.ItemSelectValidatorBinding
import org.json.JSONArray
import org.json.JSONObject

class SelectValidatorAdapter(
    private val context: Context, var entities: JSONArray = JSONArray(), val onSelect: (entity: JSONObject) -> Unit
) : RecyclerView.Adapter<SelectValidatorViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SelectValidatorViewHolder {
        val binding = ItemSelectValidatorBinding.inflate(LayoutInflater.from(context), parent, false)
        return SelectValidatorViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: SelectValidatorViewHolder, position: Int) {
        val entity = entities.getJSONObject(position)
        viewHolder.binding.logo.setImageURI(entity.getString("imageUrl"))
        viewHolder.binding.name.text = entity.getString("name")
        viewHolder.binding.description.text = "Commission : ${entity.getString("commissionRate").toDouble() * 0.01}%"
        viewHolder.binding.wrap.setOnClickListener {
            onSelect(entity)
        }
    }

    override fun getItemCount(): Int {
        return entities.length()
    }
}