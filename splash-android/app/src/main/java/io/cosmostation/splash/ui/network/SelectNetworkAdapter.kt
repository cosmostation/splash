package io.cosmostation.splash.ui.network

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.databinding.ItemSelectNetworkBinding
import io.cosmostation.splash.util.Prefs
import io.cosmostation.splash.util.visibleOrInvisible

class SelectNetworkAdapter(
    private val context: Context, private val networks: List<String>, val onSelectNetwork: (network: String) -> Unit
) : RecyclerView.Adapter<SelectNetworkViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SelectNetworkViewHolder {
        val binding = ItemSelectNetworkBinding.inflate(LayoutInflater.from(context), parent, false)
        return SelectNetworkViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: SelectNetworkViewHolder, position: Int) {
        val network = networks[position]

//        val textColor = if (network == SelectNetworkFragment.NETWORK_MAIN) {
//            R.color.color_mode_base04
//        } else {
//            R.color.color_mode_base05
//        }

        viewHolder.binding.rpc.text = SplashConstants.networks[network]?.rpcUrl
        viewHolder.binding.network.text = network
        viewHolder.binding.network.setTextColor(ContextCompat.getColor(context, R.color.color_mode_base05))
        viewHolder.binding.check.visibleOrInvisible(network == Prefs.network)
        viewHolder.binding.wrap.setOnClickListener {
//            if (network == SelectNetworkFragment.NETWORK_MAIN) {
//                return@setOnClickListener
//            }
            onSelectNetwork(network)
        }
    }

    override fun getItemCount(): Int {
        return networks.size
    }
}