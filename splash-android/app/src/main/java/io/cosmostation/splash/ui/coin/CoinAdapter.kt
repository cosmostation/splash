package io.cosmostation.splash.ui.coin

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import coil.ImageLoader
import coil.decode.SvgDecoder
import coil.request.ImageRequest
import coil.transform.RoundedCornersTransformation
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.databinding.ItemCoinBinding
import io.cosmostation.splash.model.network.Balance
import io.cosmostation.splash.model.network.CoinMetadata
import io.cosmostation.splash.util.DecimalUtils

class CoinAdapter(
    private val context: Context,
    var coins: List<Balance> = listOf(),
    var metadataMap: Map<String, CoinMetadata?> = mapOf()
) : RecyclerView.Adapter<CoinViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CoinViewHolder {
        val binding = ItemCoinBinding.inflate(LayoutInflater.from(context), parent, false)
        return CoinViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: CoinViewHolder, position: Int) {
        val coin = coins[position]
        viewHolder.binding.apply {
            metadataMap[coin.coinType]?.let {
                if (it.symbol == "SUI") {
                    image.setImageResource(R.drawable.token_sui)
                } else {
                    it.iconUrl?.let { url ->
                        val imageLoader = ImageLoader.Builder(context).components {
                            add(SvgDecoder.Factory())
                        }.placeholder(R.drawable.token_default).build()
                        val request = ImageRequest.Builder(context).data(url).target(image)
                            .transformations(RoundedCornersTransformation(20f)).build()
                        val disposable = imageLoader.enqueue(request)
                    }
                }
                balance.text = DecimalUtils.toString(coin.totalBalance, it.decimals)
            } ?: run {
                if (coin.coinType == SplashConstants.SUI_BALANCE_DENOM) {
                    image.setImageResource(R.drawable.token_sui)
                } else {
                    image.setImageResource(R.drawable.token_default)
                }
                balance.text = DecimalUtils.toString(coin.totalBalance)
            }
            token.text = coin.coinType.substring(
                coin.coinType.lastIndexOf("::") + 2, coin.coinType.length
            )
            wrap.setOnClickListener {
                context.startActivity(
                    Intent(context, CoinSendActivity::class.java).putExtra(
                        "denom", coin.coinType
                    )
                )
            }
        }
    }

    override fun getItemCount(): Int {
        return coins.size
    }
}
