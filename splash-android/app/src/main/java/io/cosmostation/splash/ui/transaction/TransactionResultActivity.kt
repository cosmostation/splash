package io.cosmostation.splash.ui.transaction

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.databinding.ActivityTransactionResultBinding
import io.cosmostation.splash.util.visibleOrGone
import org.json.JSONObject

class TransactionResultActivity : AppCompatActivity() {
    private lateinit var binding: ActivityTransactionResultBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityTransactionResultBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        loadData()
    }

    private fun loadData() {
        val executeResult = intent.getStringExtra("executeResult")
        executeResult?.let {
            try {
                val status = JSONObject(it).getJSONObject("effects").getJSONObject("status").getString("status")
                settingResultView(status == "success")
            } catch (e: Exception) {
                settingResultView(false)
            }
            try {
                val digest = JSONObject(it).getString("digest")
                binding.explorerBtn.setOnClickListener {
                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(SplashConstants.txDetailUrl(digest))))
                }
                binding.explorerBtn.visibleOrGone(true)
            } catch (_: Exception) {
            }
        } ?: run {
            settingResultView(false)
        }
    }

    private fun settingResultView(success: Boolean) {
        if (success) {
            binding.resultImage.setImageResource(R.drawable.transaction_success_light)
            binding.resultText.text = getString(R.string.transaction_success)
            binding.resultText.setTextColor(
                ContextCompat.getColor(this, R.color.color_green01)
            )
        } else {
            binding.resultImage.setImageResource(R.drawable.transaction_fail_light)
            binding.resultText.text = getString(R.string.transaction_fail)
            binding.resultText.setTextColor(ContextCompat.getColor(this, R.color.color_accent))
        }
    }

    private fun setupViews() {
        binding.confirmBtn.setOnClickListener {
            finish()
        }
    }
}