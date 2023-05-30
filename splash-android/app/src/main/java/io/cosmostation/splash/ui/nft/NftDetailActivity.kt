package io.cosmostation.splash.ui.nft

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import coil.ImageLoader
import coil.decode.SvgDecoder
import coil.request.ImageRequest
import coil.transform.RoundedCornersTransformation
import com.google.gson.Gson
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.ActivityNftDetailBinding
import io.cosmostation.splash.ui.common.ActionBarBaseActivity
import io.cosmostation.suikotlin.SuiClient
import org.json.JSONObject
import java.net.URLEncoder

class NftDetailActivity : ActionBarBaseActivity() {
    private lateinit var binding: ActivityNftDetailBinding

    override val titleResourceId: Int
        get() = R.string.nft_detail

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityNftDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        loadData()
    }

    private fun loadData() {
        val id = intent.getStringExtra("id")
        id?.let {
            val objects = SplashWalletApp.instance.applicationViewModel.nftMap[it]
            objects?.let {
                val contentJson = JSONObject(Gson().toJson(objects.content))
                binding.type.text = objects.type
                binding.objectId.text = id
                try {
                    val url = contentJson.getJSONObject("fields").getString("url").replace("ipfs://", SplashConstants.IPFS)
                    val imageLoader = ImageLoader.Builder(this).components {
                        add(SvgDecoder.Factory())
                    }.placeholder(R.drawable.nft_default).build()
                    val request = ImageRequest.Builder(this).data(url).target(binding.image).size(640).transformations(RoundedCornersTransformation(20f)).build()
                    val disposable = imageLoader.enqueue(request)
                    binding.title.text = contentJson.getJSONObject("fields").getString("name")
                    binding.description.text = contentJson.getJSONObject("fields").getString("description")
                } catch (_: Exception) {
                }
            }
        }
    }

    private fun setupViews() {
        binding.nextBtn.setOnClickListener {
            startActivity(Intent(this, NftSendActivity::class.java).putExtra("id", intent.getStringExtra("id")))
            finish()
        }
        binding.explorerBtn.setOnClickListener {
            val id = intent.getStringExtra("id")
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(SplashConstants.objectDetailUrl(URLEncoder.encode(id, "utf-8"), SuiClient.instance.currentNetwork.name)))
            startActivity(intent)
        }
    }
}