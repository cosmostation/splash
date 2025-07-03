package io.cosmostation.splash

import android.app.Application
import android.os.Build
import android.webkit.WebView
import androidx.appcompat.app.AppCompatDelegate
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.ViewModelStoreOwner
import com.facebook.drawee.backends.pipeline.Fresco
import com.facebook.imagepipeline.core.ImagePipelineConfig
import com.facebook.imagepipeline.core.ImageTranscoderType
import com.facebook.imagepipeline.core.MemoryChunkType
import com.walletconnect.android.Core
import com.walletconnect.android.CoreClient
import com.walletconnect.android.relay.ConnectionType
import com.walletconnect.sign.client.Sign
import com.walletconnect.sign.client.SignClient
import io.cosmostation.splash.secure.CipherHelper
import io.cosmostation.splash.util.Prefs
import io.cosmostation.splash.util.ThemeUtils
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.Network

class SplashWalletApp : Application(), ViewModelStoreOwner {
    companion object {
        lateinit var instance: SplashWalletApp
            private set
    }

    init {
        instance = this
    }

    private val mViewModelStore = ViewModelStore()
    lateinit var applicationViewModel: ApplicationViewModel

    override val viewModelStore: ViewModelStore
        get() = mViewModelStore

    override fun onCreate() {
        super.onCreate()
        applicationViewModel = ViewModelProvider(
            this,
            ViewModelProvider.AndroidViewModelFactory(this)
        )[ApplicationViewModel::class.java]
        CipherHelper.init(this)
        SuiClient.initialize()
        val network = SplashConstants.networks[Prefs.network] ?: Network.Mainnet()
        SuiClient.configure(network)
        setupFresco()
        initWalletConnect()
        ThemeMode()
        WebView.setWebContentsDebuggingEnabled(true)
    }

    private fun setupFresco() {
        Fresco.initialize(
            applicationContext,
            ImagePipelineConfig.newBuilder(applicationContext)
                .setMemoryChunkType(MemoryChunkType.BUFFER_MEMORY)
                .setImageTranscoderType(ImageTranscoderType.JAVA_TRANSCODER).experiment()
                .setNativeCodeDisabled(true).build()
        )
    }

    private fun initWalletConnect() {
        val projectId = "c86a509bcec2bed45131d2d9980cfe7d"
        val relayUrl = "relay.walletconnect.com"
        val serverUrl = "wss://$relayUrl?projectId=$projectId"
        val connectionType = ConnectionType.AUTOMATIC
        val metaData = Core.Model.AppMetaData(
            getString(R.string.app_name),
            getString(R.string.app_name),
            getString(R.string.app_name),
            listOf(),
            "splashwallet://wc"
        )
        CoreClient.initialize(metaData, serverUrl, connectionType, this, null)
        SignClient.initialize(Sign.Params.Init(CoreClient)) {}
    }

    private fun ThemeMode() {
        val themeColor: String? = ThemeUtils.modLoad(applicationContext)
        ThemeUtils.applyTheme(themeColor)

        if (themeColor == ThemeUtils.DEFAULT_MODE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM)
            } else {
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_AUTO_BATTERY)
            }
        } else if (themeColor == ThemeUtils.LIGHT_MODE) {
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
        } else if (themeColor == ThemeUtils.DARK_MODE) {
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
        }
    }
}