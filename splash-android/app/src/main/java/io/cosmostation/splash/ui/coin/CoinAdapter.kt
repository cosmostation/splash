package io.cosmostation.splash.ui.coin

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import coil.ImageLoader
import coil.decode.SvgDecoder
import coil.request.ImageRequest
import coil.transform.RoundedCornersTransformation
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.ItemCoinBinding
import io.cosmostation.splash.model.network.Balance
import io.cosmostation.splash.model.network.CoinMetadata
import io.cosmostation.splash.ui.staking.StakingActivity
import io.cosmostation.splash.util.formatDecimal
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.Network
import java.math.BigDecimal

class CoinAdapter(
    private val context: Context, var coins: MutableList<Balance> = mutableListOf(), var metadataMap: Map<String, CoinMetadata?> = mapOf()
) : RecyclerView.Adapter<CoinViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CoinViewHolder {
        val binding = ItemCoinBinding.inflate(LayoutInflater.from(context), parent, false)
        return CoinViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: CoinViewHolder, position: Int) {
        val coin = coins[position]
        viewHolder.disposable?.dispose()
        viewHolder.binding.apply {
            image.setImageResource(R.drawable.token_default)
            metadataMap[coin.coinType]?.let {
                if (it.symbol == "SUI") {
                    image.setImageResource(R.drawable.token_sui)
                } else {
                    it.iconUrl?.let { url ->
                        val imageLoader = ImageLoader.Builder(context).components {
                            add(SvgDecoder.Factory())
                        }.placeholder(R.drawable.token_default).build()
                        val request = ImageRequest.Builder(context).data(url).target(image).transformations(RoundedCornersTransformation(20f)).build()
                        viewHolder.disposable = imageLoader.enqueue(request)
                    }
                }
                balance.text = coin.totalBalance.formatDecimal(it.decimals)
                token.text = it.symbol
            } ?: run {
                when (coin.coinType) {
                    SplashConstants.SUI_BALANCE_DENOM -> {
                        image.setImageResource(R.drawable.token_sui)
                    }
                    SplashConstants.SUI_STAKED_BALANCE_DENOM -> {
                        image.setImageResource(R.drawable.token_staked_sui)
                    }
                    else -> {
                        image.setImageResource(R.drawable.token_default)
                    }
                }
                balance.text = coin.totalBalance.formatDecimal()
                token.text = coin.coinType.substring(coin.coinType.lastIndexOf("::") + 2, coin.coinType.length)
            }
            onePrice.text = "$ 0.0"
            price.text = "$ 0.0"
            changes.text = ""
            if (SuiClient.instance.currentNetwork.name == Network.Mainnet().name) {
                SplashWalletApp.instance.applicationViewModel.priceMap.value?.let { priceMap ->
                    SplashConstants.coingeckoIdMap[coin.coinType]?.let { coinType ->
                        val tokenPrice = priceMap[coinType]?.get("usd")
                        val tokenChange = priceMap[coinType]?.get("usd_24h_change")
                        tokenPrice?.let {
                            onePrice.text = String.format("$ %.2f", it)
                            price.text = String.format("$ %.2f", BigDecimal(it).multiply(BigDecimal(coin.totalBalance.formatDecimal())))
                        }
                        tokenChange?.let {
                            if (it >= 0) {
                                changes.setTextColor(ContextCompat.getColor(context, R.color.color_green01))
                                changes.text = "${String.format("+%.1f", it)}%"
                            } else {
                                changes.setTextColor(ContextCompat.getColor(context, R.color.color_red01))
                                changes.text = "${String.format("%.1f", it)}%"
                            }
                        }
                    }
                }
            }

            wrap.setOnClickListener {
                if (coin.coinType == SplashConstants.SUI_STAKED_BALANCE_DENOM) {
                    context.startActivity(Intent(context, StakingActivity::class.java))
                } else {
                    context.startActivity(Intent(context, CoinSendActivity::class.java).putExtra("denom", coin.coinType))
                }
            }
        }
    }

    override fun getItemCount(): Int {
        return coins.size
    }
}
