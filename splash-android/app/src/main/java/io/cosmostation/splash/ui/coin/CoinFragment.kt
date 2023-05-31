package io.cosmostation.splash.ui.coin

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.gson.Gson
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanIntentResult
import com.journeyapps.barcodescanner.ScanOptions
import io.cosmostation.splash.R
import io.cosmostation.splash.SplashConstants
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.FragmentCoinBinding
import io.cosmostation.splash.model.network.Balance
import io.cosmostation.splash.ui.account.select.SelectAccountFragment
import io.cosmostation.splash.ui.app.WalletConnectActivity
import io.cosmostation.splash.ui.nft.NftAdapter
import io.cosmostation.splash.ui.staking.StakingActivity
import io.cosmostation.splash.ui.wallet.WalletReceiveActivity
import io.cosmostation.splash.util.formatDecimal
import io.cosmostation.splash.util.visibleOrGone
import io.cosmostation.suikotlin.SuiClient
import io.cosmostation.suikotlin.model.Network
import org.json.JSONObject
import java.math.BigDecimal
import java.math.RoundingMode

class CoinFragment : Fragment() {
    private lateinit var binding: FragmentCoinBinding
    private lateinit var coinAdapter: CoinAdapter
    private lateinit var nftAdapter: NftAdapter
    private val viewModel: CoinViewModel by viewModels()
    lateinit var barcodeLauncher: ActivityResultLauncher<ScanOptions>
    var currentTab = MainTab.COIN

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentCoinBinding.inflate(layoutInflater, container, false)
        setupRecyclerView()
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupLiveData()
        setupViews()
        setupViewModels()
        setupBarcodeReader()
    }

    override fun onStart() {
        super.onStart()
        requireActivity().window.statusBarColor = ContextCompat.getColor(requireContext(), R.color.color_gradient01_start)
    }

    override fun onStop() {
        super.onStop()
        requireActivity().window.statusBarColor = ContextCompat.getColor(requireContext(), R.color.color_mode_base01)
    }

    private fun setupBarcodeReader() {
        barcodeLauncher = registerForActivityResult(ScanContract()) { result: ScanIntentResult ->
            if (result.contents != null) {
                val intent = Intent(requireContext(), WalletConnectActivity::class.java)
                intent.putExtra(WalletConnectActivity.INTENT_WC_URL_KEY, result.contents)
                startActivity(intent)
            }
        }
    }

    private fun setupViews() {
        binding.assetCount.setOnClickListener {
            changeTab(MainTab.COIN)
        }

        binding.nftCount.setOnClickListener {
            changeTab(MainTab.NFT)
        }

        binding.faucetBtn.setOnClickListener {
            SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.address?.let {
                SplashWalletApp.instance.applicationViewModel.increaseFetchCount()
                viewModel.faucetClick(it)
                SplashWalletApp.instance.applicationViewModel.decreaseFetchCount()
            }
        }

        binding.explorer.setOnClickListener {
            SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.address?.let {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(SplashConstants.accountDetailUrl(it, SuiClient.instance.currentNetwork.name)))
                startActivity(intent)
            }
        }

        binding.sendBtn.setOnClickListener {
            startActivity(Intent(context, CoinSendActivity::class.java).putExtra(CoinSendActivity.INTENT_DENOM_KEY, SplashConstants.SUI_BALANCE_DENOM))
        }

        binding.receiveBtn.setOnClickListener {
            SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.let { wallet ->
                startActivity(Intent(context, WalletReceiveActivity::class.java).putExtra(WalletReceiveActivity.INTENT_ADDRESS_KEY, wallet.address))
            }
        }

        binding.stakingBtn.setOnClickListener {
            startActivity(Intent(context, StakingActivity::class.java))
        }

        binding.accountBtn.setOnClickListener {
            SelectAccountFragment().show(parentFragmentManager, SelectAccountFragment::class.java.name)
        }
    }

    private fun setupViewModels() {
        viewModel.faucet.observe(viewLifecycleOwner) {
            if (it == false) {
                Toast.makeText(context, "Faucet failed !", Toast.LENGTH_LONG).show()
                return@observe
            }
            context?.let { context ->
                Toast.makeText(context, "Faucet success !", Toast.LENGTH_LONG).show()
                SplashWalletApp.instance.applicationViewModel.loadAllData()
            }
        }

        viewModel.toast.observe(viewLifecycleOwner) {
            context?.let { context ->
                Toast.makeText(context, it, Toast.LENGTH_LONG).show()
            }
        }

        viewModel.stakeAmount.observe(viewLifecycleOwner) {
            coinAdapter.coins.find { it.coinType == SplashConstants.SUI_STAKED_BALANCE_DENOM }?.let { find ->
                find.totalBalance = it
            } ?: run {
                coinAdapter.coins.add(Balance(SplashConstants.SUI_STAKED_BALANCE_DENOM, 1, it))
            }
            coinAdapter.coins = coinAdapter.coins.sortedBy { if (SplashConstants.SUI_BALANCE_DENOM == it.coinType) "00" else if (it.coinType == SplashConstants.SUI_STAKED_BALANCE_DENOM) "01" else it.coinType }.toMutableList()
            binding.assetCount.text = "${getString(R.string.coins2)} (${coinAdapter.coins.size})"
            coinAdapter.notifyDataSetChanged()
            updateTotalBalance()
        }
    }

    private fun updateTotalBalance() {
        if (SuiClient.instance.currentNetwork.name == Network.Mainnet().name) {
            var total = BigDecimal(0)
            coinAdapter.coins.forEach { coin ->
                SplashWalletApp.instance.applicationViewModel.priceMap.value?.let { priceMap ->
                    SplashConstants.coingeckoIdMap[coin.coinType]?.let { coinType ->
                        val tokenPrice = priceMap[coinType]?.get("usd")
                        tokenPrice?.let {
                            total += BigDecimal(it).multiply(BigDecimal(coin.totalBalance.formatDecimal()))
                        }
                    }
                }
            }
            binding.price.text = "$ ${total.setScale(2, RoundingMode.DOWN)}"
        } else {
            binding.price.text = "$ 0.00"
        }
    }

    private fun setupRecyclerView() {
        coinAdapter = CoinAdapter(requireContext())
        binding.recycler.layoutManager = LinearLayoutManager(activity)
        binding.recycler.adapter = coinAdapter

        nftAdapter = NftAdapter(requireContext())
        binding.nftRecycler.layoutManager = GridLayoutManager(activity, 2)
        binding.nftRecycler.adapter = nftAdapter
    }

    private fun setupLiveData() {
        SplashWalletApp.instance.applicationViewModel.priceMap.observe(viewLifecycleOwner) {
            coinAdapter.notifyDataSetChanged()
            updateTotalBalance()
        }

        SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.observe(viewLifecycleOwner) {
            it?.let {
                binding.accountName.text = it.name
            }

            binding.network.text = SuiClient.instance.currentNetwork.name
            if (SuiClient.instance.currentNetwork.name == Network.Mainnet().name) {
                binding.network.setTextColor(ContextCompat.getColor(requireContext(), R.color.color_blue04))
            } else {
                binding.network.setTextColor(ContextCompat.getColor(requireContext(), R.color.color_mode_base04))
            }
            binding.faucetBtn.visibleOrGone(SuiClient.instance.currentNetwork.faucetUrl.isNotEmpty())
        }

        SplashWalletApp.instance.applicationViewModel.allBalances.observe(viewLifecycleOwner) { balances ->
            SplashWalletApp.instance.applicationViewModel.currentWalletLiveData.value?.address?.let {
                viewModel.loadStake(it)
            }
            coinAdapter.coins = balances.toMutableList()
            binding.assetCount.text = "${getString(R.string.coins2)} (${coinAdapter.coins.size})"
            coinAdapter.notifyDataSetChanged()
            updateTabStatus()
        }

        SplashWalletApp.instance.applicationViewModel.allObjectsLiveData.observe(viewLifecycleOwner) { item ->
            item?.let {
                nftAdapter.nfts.clear()
                val nfts = item.filter { it.display.data != null }
                nftAdapter.nfts.addAll(nfts)

                try {
                    nfts.filter { nft ->
                        val displayJson = JSONObject(Gson().toJson(nft.display))
                        displayJson.getJSONObject("data").has("kiosk")
                    }.let {
                        SplashWalletApp.instance.applicationViewModel.loadDynamicFields(it[0].display.data.kiosk)
                    }
                } catch (_: Exception) {
                    binding.nftCount.text = "${getString(R.string.nfts)} (${nfts.size})"
                }
                nftAdapter.notifyDataSetChanged()
                updateTabStatus()
            }
        }

        SplashWalletApp.instance.applicationViewModel.coinMetadataMap.observe(viewLifecycleOwner) {
            coinAdapter.metadataMap = it
            coinAdapter.notifyDataSetChanged()
        }

        SplashWalletApp.instance.applicationViewModel.dynamicFieldData.observe(viewLifecycleOwner) {
            SplashWalletApp.instance.applicationViewModel.loadMultiObjects()
        }

        SplashWalletApp.instance.applicationViewModel.allMultiObjectsMetaLiveData.observe(viewLifecycleOwner) { item ->
            item?.let {
                if (!nftAdapter.nfts.containsAll(it)) {
                    nftAdapter.nfts.addAll(it)
                }
                binding.nftCount.text = "${getString(R.string.nfts)} (${nftAdapter.nfts.size})"
                nftAdapter.notifyDataSetChanged()
                updateTabStatus()
            }
        }
    }

    private fun changeTab(tab: MainTab) {
        if (currentTab == tab) {
            return
        }

        currentTab = tab
        updateTabStatus()
    }

    private fun updateTabStatus() {
        if (currentTab == MainTab.COIN) {
            binding.assetCount.setTextColor(ContextCompat.getColor(requireContext(), R.color.color_mode_base05))
            binding.nftCount.setTextColor(ContextCompat.getColor(requireContext(), R.color.color_mode_base04))
            binding.nftEmpty.visibleOrGone(false)
            binding.nftRecycler.visibleOrGone(false)
            binding.recycler.visibleOrGone(true)
        } else {
            binding.assetCount.setTextColor(ContextCompat.getColor(requireContext(), R.color.color_mode_base04))
            binding.nftCount.setTextColor(ContextCompat.getColor(requireContext(), R.color.color_mode_base05))
            binding.nftEmpty.visibleOrGone(nftAdapter.itemCount == 0)
            binding.nftRecycler.visibleOrGone(nftAdapter.itemCount > 0)
            binding.recycler.visibleOrGone(false)
        }
    }

    enum class MainTab {
        COIN, NFT
    }
}