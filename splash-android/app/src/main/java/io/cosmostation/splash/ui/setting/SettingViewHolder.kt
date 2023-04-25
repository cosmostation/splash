package io.cosmostation.splash.ui.setting

import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.databinding.ItemSettingButtonBinding
import io.cosmostation.splash.databinding.ItemSettingSectionBinding
import io.cosmostation.splash.databinding.ItemSettingSwitchBinding

class SectionSettingViewHolder(val binding: ItemSettingSectionBinding) : RecyclerView.ViewHolder(binding.root)

class ButtonSettingViewHolder(val binding: ItemSettingButtonBinding) : RecyclerView.ViewHolder(binding.root)

class SwitchSettingViewHolder(val binding: ItemSettingSwitchBinding) : RecyclerView.ViewHolder(binding.root)