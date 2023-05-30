package io.cosmostation.splash.ui.nft

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import coil.ImageLoader
import coil.decode.SvgDecoder
import coil.request.ImageRequest
import coil.transform.RoundedCornersTransformation
import com.google.gson.Gson
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.databinding.ItemNftBinding
import io.cosmostation.suikotlin.model.SuiObjectInfo
import org.json.JSONObject

class NftAdapter(private val context: Context, val nfts: MutableList<SuiObjectInfo> = mutableListOf()) : RecyclerView.Adapter<NftViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): NftViewHolder {
        val binding = ItemNftBinding.inflate(LayoutInflater.from(context), parent, false)
        return NftViewHolder(binding, null)
    }

    override fun onBindViewHolder(viewHolder: NftViewHolder, position: Int) {
        val nft = nfts[position]
        val displayJson = JSONObject(Gson().toJson(nft.display))
        viewHolder.binding.apply {
            try {
                viewHolder.disposable?.dispose()
                image.setImageResource(R.drawable.nft_default)
                val url = displayJson.getJSONObject("data").getString("image_url").replace("ipfs://", SplashConstants.IPFS)
                val imageLoader = ImageLoader.Builder(context).components {
                    add(SvgDecoder.Factory())
                }.placeholder(R.drawable.nft_default).build()
                val request = ImageRequest.Builder(context).data(url).target(image).size(320).transformations(RoundedCornersTransformation(20f)).build()
                viewHolder.disposable = imageLoader.enqueue(request)
            } catch (_: Exception) { }

            try {
                title.text = displayJson.getJSONObject("data").getString("name")
            } catch (e: Exception) {
                title.text = nft.objectId
            }
            wrap.setOnClickListener {
                context.startActivity(Intent(context, NftDetailActivity::class.java).putExtra("id", nft.objectId))
            }
        }
    }

    override fun getItemCount(): Int {
        return nfts.size
    }
}