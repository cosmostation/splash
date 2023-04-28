package io.cosmostation.splash.ui.account.select

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.databinding.ItemSelectAccountBinding
import io.cosmostation.splash.util.visibleOrInvisible

class SelectAccountAdapter(
    private val context: Context, var entities: List<Wallet> = listOf(), val onSelect: (entity: Wallet) -> Unit, val address: () -> Long
) : RecyclerView.Adapter<SelectAccountViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SelectAccountViewHolder {
        val binding = ItemSelectAccountBinding.inflate(LayoutInflater.from(context), parent, false)
        return SelectAccountViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: SelectAccountViewHolder, position: Int) {
        val entity = entities[position]
        viewHolder.binding.name.text = entity.name
        viewHolder.binding.address.text = entity.address
        viewHolder.binding.check.visibleOrInvisible(entity.id == address())
        viewHolder.binding.wrap.setOnClickListener {
            onSelect(entity)
        }
    }

    override fun getItemCount(): Int {
        return entities.size
    }
}