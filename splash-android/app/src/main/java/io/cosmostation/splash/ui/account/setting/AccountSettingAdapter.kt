package io.cosmostation.splash.ui.account.setting

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.database.Wallet
import io.cosmostation.splash.databinding.ItemAccountSettingBinding

class AccountSettingAdapter(
    private val context: Context,
    var entities: List<Wallet> = listOf(),
    val onClickMore: (view: View, entity: Wallet) -> Unit
) : RecyclerView.Adapter<AccountSettingViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): AccountSettingViewHolder {
        val binding = ItemAccountSettingBinding.inflate(LayoutInflater.from(context), parent, false)
        return AccountSettingViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: AccountSettingViewHolder, position: Int) {
        val entity = entities[position]
        viewHolder.binding.name.text = entity.name
        viewHolder.binding.address.text = entity.address
        viewHolder.binding.menu.setOnClickListener {
            onClickMore(viewHolder.binding.menu, entity)
        }
    }

    override fun getItemCount(): Int {
        return entities.size
    }
}