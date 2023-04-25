package io.cosmostation.splash.ui.wallet

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.databinding.ItemMnemonicBinding

class MnemonicAdapter(
    private val context: Context, val words: MutableList<String> = mutableListOf()
) : RecyclerView.Adapter<MnemonicViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MnemonicViewHolder {
        val binding = ItemMnemonicBinding.inflate(LayoutInflater.from(context), parent, false)
        return MnemonicViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: MnemonicViewHolder, position: Int) {
        val item = words[position]
        viewHolder.binding.apply {
            number.text = "${position + 1}".padStart(2)
            word.text = item
        }
    }

    override fun getItemCount(): Int {
        return words.size
    }
}