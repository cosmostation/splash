package io.cosmostation.splash.ui.setting

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ItemSettingButtonBinding
import io.cosmostation.splash.databinding.ItemSettingSectionBinding
import io.cosmostation.splash.databinding.ItemSettingSwitchBinding
import io.cosmostation.splash.model.SettingItem
import io.cosmostation.splash.model.SettingItemType

class SettingAdapter(private val context: Context, var items: List<SettingItem> = listOf()) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return when (viewType) {
            SettingItemType.BUTTON.ordinal -> ButtonSettingViewHolder(ItemSettingButtonBinding.inflate(LayoutInflater.from(context), parent, false))
            SettingItemType.SWITCH.ordinal -> SwitchSettingViewHolder(ItemSettingSwitchBinding.inflate(LayoutInflater.from(context), parent, false))
            else -> SectionSettingViewHolder(ItemSettingSectionBinding.inflate(LayoutInflater.from(context), parent, false))
        }
    }

    override fun onBindViewHolder(viewHolder: RecyclerView.ViewHolder, position: Int) {
        val item = items[position]
        when (viewHolder) {
            is ButtonSettingViewHolder -> {
                (item as? SettingItem.ButtonSettingItem)?.let {
                    viewHolder.binding.title.text = item.title
                    viewHolder.binding.icon.setImageResource(item.icon)
                    viewHolder.binding.badge.text = item.badge
                    viewHolder.binding.wrap.setOnClickListener { item.action() }
                }
            }
            is SwitchSettingViewHolder -> {
                (item as? SettingItem.SwitchSettingItem)?.let {
                    viewHolder.binding.title.text = item.title
                    viewHolder.binding.icon.setImageResource(item.icon)
                    viewHolder.binding.button.isChecked = item.status
                    viewHolder.binding.button.setOnCheckedChangeListener { _, isChecked ->
                        item.action(isChecked)
                    }
                }
            }
            is SectionSettingViewHolder -> {
                viewHolder.binding.title.text = item.title
            }
        }
    }

    override fun getItemCount(): Int {
        return items.size
    }

    override fun getItemViewType(position: Int): Int {
        return when (items[position]) {
            is SettingItem.ButtonSettingItem -> SettingItemType.BUTTON.ordinal
            is SettingItem.SwitchSettingItem -> SettingItemType.SWITCH.ordinal
            else -> SettingItemType.SECTION.ordinal
        }
    }
}