package io.cosmostation.splash.ui.app

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.databinding.ItemAppBinding
import io.cosmostation.splash.model.network.Dapp

class AppAdapter(
    private val context: Context, val apps: MutableList<Dapp> = mutableListOf()
) : RecyclerView.Adapter<AppViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): AppViewHolder {
        val binding = ItemAppBinding.inflate(LayoutInflater.from(context), parent, false)
        return AppViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: AppViewHolder, position: Int) {
        val app = apps[position]
        viewHolder.binding.title.text = app.name
        viewHolder.binding.description.text = app.description
        viewHolder.binding.image.setImageURI(app.icon)
        viewHolder.binding.wrap.setOnClickListener { goLink(app.link) }
    }

    override fun getItemCount(): Int {
        return apps.size
    }

    private fun goLink(link: String) {
        context.startActivity(Intent(context, DappActivity::class.java).putExtra("url", link))
    }
}