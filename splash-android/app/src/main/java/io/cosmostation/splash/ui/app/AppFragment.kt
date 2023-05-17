package io.cosmostation.splash.ui.app

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.fragment.app.Fragment
import io.cosmostation.splash.BuildConfig
import io.cosmostation.splash.databinding.FragmentAppBinding
import io.cosmostation.splash.util.ThemeUtils

class AppFragment : Fragment() {
    private lateinit var binding: FragmentAppBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentAppBinding.inflate(layoutInflater, container, false)
        setupWebView()
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.webview.loadUrl("https://dapps.splash.im/?theme=${(ThemeUtils.currentMode(requireContext()) ?: "").lowercase()}")
    }

    private fun setupWebView() {
        binding.webview.settings.javaScriptEnabled = true
        binding.webview.settings.userAgentString = binding.webview.settings.userAgentString + " Splash/APP/DappTab/Android" + BuildConfig.VERSION_NAME
        binding.webview.settings.domStorageEnabled = true
        binding.webview.settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
        binding.webview.webChromeClient = WebChromeClient()
        binding.webview.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView?, url: String?) {
                binding.webview.visibility = View.VISIBLE
                super.onPageFinished(view, url)
            }

            override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
                if (url.startsWith("intent:")) {
                    try {
                        val intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
                        val existPackage: Intent? = intent.getPackage()?.let {
                            activity?.packageManager?.getLaunchIntentForPackage(it)
                        }
                        if (existPackage != null) {
                            startActivity(intent)
                        } else {
                            val marketIntent = Intent(Intent.ACTION_VIEW)
                            marketIntent.data = Uri.parse("market://details?id=" + intent.getPackage())
                            startActivity(marketIntent)
                        }
                        return true
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                } else {
                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                    return true
                }
                return false
            }
        }
    }
}