package io.cosmostation.splash.ui.nft

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import io.cosmostation.splash.SplashWalletApp
import io.cosmostation.splash.databinding.FragmentNftBinding
import io.cosmostation.splash.util.visibleOrGone

class NftFragment : Fragment() {

    private lateinit var adapter: NftAdapter
    private lateinit var binding: FragmentNftBinding

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        binding = FragmentNftBinding.inflate(layoutInflater, container, false)
        adapter = NftAdapter(requireContext())
        binding.recycler.layoutManager = GridLayoutManager(activity, 2)
        binding.recycler.adapter = adapter
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        observeLiveData()
    }

    private fun observeLiveData() {
        SplashWalletApp.instance.applicationViewModel.allObjectsLiveData.observe(viewLifecycleOwner) { item ->
            item?.let {
                adapter.nfts.clear()
                val nfts = item.filter {
                    !it.type.contains("Coin", true)
                }
                binding.empty.visibleOrGone(nfts.isEmpty())
                binding.recycler.visibleOrGone(nfts.isNotEmpty())
                binding.count.text = "${nfts.size}"
                adapter.nfts.addAll(nfts)
                adapter.notifyDataSetChanged()
            }
        }
    }
}
