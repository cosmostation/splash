package io.cosmostation.splash.ui.main

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.ActivityMainBinding
import io.cosmostation.splash.ui.activity.ActivityFragment
import io.cosmostation.splash.ui.app.AppFragment
import io.cosmostation.splash.ui.coin.CoinFragment
import io.cosmostation.splash.ui.setting.SettingFragment
import io.cosmostation.splash.ui.wallet.WalletAddIntroActivity
import io.cosmostation.splash.util.visibleOrGone

class MainActivity : AppCompatActivity() {

    private val fragmentManager = supportFragmentManager
    private val walletFragment: Fragment = CoinFragment()
    private val appFragment: Fragment = AppFragment()
    private val activityFragment: Fragment = ActivityFragment()
    private val settingFragment: Fragment = SettingFragment()
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupFragment()
        setupLiveData()
        binding.bottomNavigation.postDelayed({
            binding.bottomNavigation.selectedItemId = R.id.navigation_coins
        }, 250)
    }

    override fun onResume() {
        super.onResume()
        SplashWalletApp.instance.applicationViewModel.loadWallet()
    }

    private fun setupLiveData() {
        SplashWalletApp.instance.applicationViewModel.fetchCount.observe(this) {
            binding.loading.visibleOrGone(it > 0)
            if (it <= 0) {
                binding.refresh.isRefreshing = false
            }
        }

        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.observe(this) {
            if (it == null) {
                startActivity(Intent(this, WalletAddIntroActivity::class.java))
            } else {
                SplashWalletApp.instance.applicationViewModel.loadAllData()
            }
        }
    }

    private fun setupFragment() {
        binding.refresh.setOnRefreshListener {
            SplashWalletApp.instance.applicationViewModel.loadAllData()
        }

        val fragmentTransaction = fragmentManager.beginTransaction()
        fragmentTransaction.replace(R.id.fragment_container, walletFragment).commitNow()

        binding.bottomNavigation.setOnNavigationItemSelectedListener { menuItem ->
            val transaction = fragmentManager.beginTransaction()

            binding.refresh.isEnabled = true
            when (menuItem.itemId) {
                R.id.navigation_coins -> {
                    transaction.replace(
                        R.id.fragment_container, walletFragment, getString(R.string.coins)
                    ).commitAllowingStateLoss()
                }
                R.id.navigation_apps -> {
                    binding.refresh.isEnabled = false
                    transaction.replace(
                        R.id.fragment_container, appFragment, getString(R.string.app)
                    ).commitAllowingStateLoss()
                }
                R.id.navigation_activity -> {
                    transaction.replace(
                        R.id.fragment_container, activityFragment, getString(R.string.activity)
                    ).commitAllowingStateLoss()
                }
                R.id.navigation_setting -> {
                    transaction.replace(
                        R.id.fragment_container, settingFragment, getString(R.string.setting)
                    ).commitAllowingStateLoss()
                }
                else -> {}
            }
            true
        }
    }
}

