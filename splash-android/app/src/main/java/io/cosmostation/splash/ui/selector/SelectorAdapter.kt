package io.cosmostation.splash.ui.selector

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.databinding.ItemSelectorBinding
import io.cosmostation.splash.util.visibleOrInvisible

class SelectorAdapter(
    private val context: Context, private val items: List<String>, private val current: String, val onSelect: (item: String) -> Unit
) : RecyclerView.Adapter<SelectorViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SelectorViewHolder {
        val binding = ItemSelectorBinding.inflate(LayoutInflater.from(context), parent, false)
        return SelectorViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: SelectorViewHolder, position: Int) {
        val item = items[position]
        viewHolder.binding.item.text = item
        viewHolder.binding.check.visibleOrInvisible(current == item)
        viewHolder.binding.wrap.setOnClickListener {
            if (current == item) {
                return@setOnClickListener
            }
            onSelect(item)
        }
    }

    override fun getItemCount(): Int {
        return items.size
    }
}