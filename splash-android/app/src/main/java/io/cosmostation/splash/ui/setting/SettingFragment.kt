package io.cosmostation.splash.ui.setting

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.FragmentSettingBinding
import io.cosmostation.splash.model.SettingItem
import io.cosmostation.splash.ui.account.select.SelectAccountFragment
import io.cosmostation.splash.ui.network.SelectNetworkFragment
import io.cosmostation.splash.ui.selector.SelectorFragment
import io.cosmostation.splash.util.ThemeUtils
import io.cosmostation.splash.util.getAppVersion
import io.cosmostation.suikotlin.SuiClient

class SettingFragment : Fragment() {
    private lateinit var binding: FragmentSettingBinding
    private lateinit var adapter: SettingAdapter

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentSettingBinding.inflate(layoutInflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupRecyclerView()
        setupViewModels()
    }

    private fun setupViewModels() {
        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.observe(viewLifecycleOwner) {
            loadSettingItems()
        }
    }

    private fun setupRecyclerView() {
        adapter = SettingAdapter(requireContext())
        binding.recycler.layoutManager = LinearLayoutManager(activity)
        binding.recycler.adapter = adapter
    }

    override fun onResume() {
        super.onResume()
        loadSettingItems()
    }

    private fun loadSettingItems() {
        val settingItems: List<SettingItem> = listOf(
            SettingItem.SectionSettingItem("Wallet"),

            SettingItem.ButtonSettingItem("Account", R.drawable.setting_account, SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.name ?: "") {
                SelectAccountFragment().show(parentFragmentManager, SelectAccountFragment::class.java.name)
            },

            SettingItem.ButtonSettingItem("Network", R.drawable.setting_network, SuiClient.instance.currentNetwork.name) {
                SelectNetworkFragment().show(parentFragmentManager, SelectNetworkFragment::class.java.name)
            },

            SettingItem.SectionSettingItem("General"),

            SettingItem.ButtonSettingItem("Theme", R.drawable.setting_theme, loadCurrentTheme()) {
                SelectorFragment("Select theme", listOf(ThemeUtils.DEFAULT_MODE, ThemeUtils.DARK_MODE, ThemeUtils.LIGHT_MODE), loadCurrentTheme()) {
                    ThemeUtils.applyTheme(it)
                    ThemeUtils.modSave(requireContext(), it)
                }.show(parentFragmentManager, SelectorFragment::class.java.name)
            },

//            SettingItem.SectionSettingItem("Security"),
//
//            SettingItem.SwitchSettingItem("App lock", R.drawable.setting_app_lock, Prefs.settingAppLock) {
//                Prefs.settingAppLock = it
//            },

            SettingItem.SectionSettingItem("App info"),

            SettingItem.ButtonSettingItem("Github", R.drawable.setting_github, "") {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(SplashConstants.SPLASH_GITHUB))
                startActivity(intent)
            },

            SettingItem.ButtonSettingItem("Version", R.drawable.setting_version, getAppVersion(requireContext())?.versionName ?: "") {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(SplashConstants.SPLASH_PLAY_STORE))
                startActivity(intent)
            },

//            SettingItem.ButtonSettingItem("Share with friends", R.drawable.setting_share, "") {
//                val intent = Intent(Intent.ACTION_SEND)
//                intent.type = "text/plain"
//                intent.setPackage("com.twitter.android")
//                val Test_Message: String = textBody
//                intent.putExtra(Intent.EXTRA_TEXT, "Test_Message")
//
//                val Sharing = Intent.createChooser(intent, "공유하기")
//                context!!.startActivity(Sharing)
//            },

            SettingItem.ButtonSettingItem("Twitter", R.drawable.setting_twitter, "") {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(SplashConstants.SPLASH_TWITTER))
                startActivity(intent)
            },

            SettingItem.ButtonSettingItem("Support", R.drawable.setting_support, "") {
                val intent = Intent(Intent.ACTION_SENDTO).apply {
                    type = "text/plain"
                    data = Uri.parse("mailto:")
                    putExtra(Intent.EXTRA_EMAIL, arrayOf(SplashConstants.SPLASH_EMAIL))
                }
                startActivity(Intent.createChooser(intent, "Send mail"))
            },
        )

        adapter.items = settingItems
        adapter.notifyDataSetChanged()
    }

    private fun loadCurrentTheme(): String {
        val theme = if (ThemeUtils.modLoad(requireContext()).equals(ThemeUtils.LIGHT_MODE)) {
            ThemeUtils.LIGHT_MODE
        } else if (ThemeUtils.modLoad(requireContext()).equals(ThemeUtils.DARK_MODE)) {
            ThemeUtils.DARK_MODE
        } else {
            ThemeUtils.DEFAULT_MODE
        }
        return theme
    }
}
