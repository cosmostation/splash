package io.cosmostation.splash.ui.password

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.databinding.ItemPinBinding
import io.cosmostation.splash.util.visibleOrGone

class PinAdapter(
    private val context: Context,
    var numbers: List<String> = listOf(),
    val onClick: (String) -> Unit
) : RecyclerView.Adapter<PinViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PinViewHolder {
        val binding = ItemPinBinding.inflate(LayoutInflater.from(context), parent, false)
        return PinViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: PinViewHolder, position: Int) {
        val item = numbers[position]
        viewHolder.binding.apply {
            number.visibleOrGone(item != "D")
            back.visibleOrGone(item == "D")
            if (item != "D") {
                number.text = item
            }
            wrap.setOnClickListener {
                onClick(item)
            }
        }
    }

    override fun getItemCount(): Int {
        return numbers.size
    }
}