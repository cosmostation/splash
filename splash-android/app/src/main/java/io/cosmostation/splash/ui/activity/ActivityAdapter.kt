package io.cosmostation.splash.ui.activity

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.google.gson.Gson
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.ItemActivityBinding
import io.cosmostation.splash.util.formatToViewTimeDefaults
import io.cosmostation.suikotlin.model.SuiTransaction
import org.json.JSONObject
import java.net.URLEncoder
import java.util.*

class ActivityAdapter(
    private val context: Context, var transactions: List<SuiTransaction> = listOf()
) : RecyclerView.Adapter<ActivityViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ActivityViewHolder {
        val binding = ItemActivityBinding.inflate(LayoutInflater.from(context), parent, false)
        return ActivityViewHolder(binding)
    }

    override fun onBindViewHolder(viewHolder: ActivityViewHolder, position: Int) {
        val transaction = transactions[position]
        try {
            val datetime = Date(transaction.timestampMs).formatToViewTimeDefaults()
            val address = JSONObject(Gson().toJson(transaction.transaction)).getJSONObject("data").getString("sender")
            val currentAddress = SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value!!.address
            viewHolder.binding.date.text = datetime
            viewHolder.binding.digest.text = transaction.digest
            viewHolder.binding.address.text = address
            viewHolder.binding.type.text = if (address == currentAddress) "(To)" else "(From)"
            val status = JSONObject(Gson().toJson(transaction.effects)).getJSONObject("status").getString("status")
            if (status == "success") {
                viewHolder.binding.image.setImageResource(R.drawable.transaction_success_light)
            } else {
                viewHolder.binding.image.setImageResource(R.drawable.transaction_fail_light)
            }
            viewHolder.binding.wrap.setOnClickListener {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(SplashConstants.txDetailUrl(URLEncoder.encode(transaction.digest, "utf-8"))))
                context.startActivity(intent)
            }
            viewHolder.binding.wrap.visibility = View.VISIBLE
        } catch (e: Exception) {
            viewHolder.binding.wrap.visibility = View.GONE
        }
    }

    override fun getItemCount(): Int {
        return transactions.size
    }
}