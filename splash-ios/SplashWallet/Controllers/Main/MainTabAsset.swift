//
//  MainTabAsset.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/01/07.
//

import UIKit
import SwiftyJSON
import MaterialComponents

class MainTabAsset: BaseVC, SelectAccountDelegate, MDCTabBarViewDelegate {
    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var chainLabel: UILabel!
    
    @IBOutlet weak var dashLayer: UIView!
    @IBOutlet weak var dashBalanceLabel: UILabel!
    @IBOutlet weak var dashBtnSend: UIButton!
    @IBOutlet weak var dashBtnReceive: UIButton!
    @IBOutlet weak var dashBtnFaucet: UIButton!
    @IBOutlet weak var dashBtnStake: UIButton!
    
    @IBOutlet weak var assetTabbar: MDCTabBarView!
    @IBOutlet weak var coinsLayer: UIView!
    @IBOutlet weak var nftsLayer: UIView!
    
    
    var mainTab: MainTab!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTab = (self.parent)?.parent as? MainTab
        
        dashBtnSend.alignTextBelow()
        dashBtnReceive.alignTextBelow()
        dashBtnFaucet.alignTextBelow()
        dashBtnStake.alignTextBelow()
        onSetTabbarView()
        
        accountView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickAccount)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAccountReady), name: Notification.Name("AccountReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDataFetched), name: Notification.Name("DataFetched"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        onSetDashView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AccountReady"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DataFetched"), object: nil)
    }
    
    func onSetDashView() {
        let gradient = CAGradientLayer()
        gradient.frame = dashLayer.bounds
        gradient.colors = [UIColor.sui_dash_start.cgColor, UIColor.sui_dash_end.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        dashLayer.layer.insertSublayer(gradient, at: 0)
    }
    
    func onSetTabbarView() {
        let coinTabBar = UITabBarItem(title: "Coins (0)", image: nil, tag: 0)
        let nftTabBar = UITabBarItem(title: "NFTs (0)", image: nil, tag: 1)
        assetTabbar.items = [ coinTabBar, nftTabBar]
        assetTabbar.barTintColor = .base01
        assetTabbar.selectionIndicatorStrokeColor = .base01
        assetTabbar.setTitleFont(font3, for: .normal)
        assetTabbar.setTitleFont(font3, for: .selected)
        assetTabbar.setTitleColor(UIColor.base04, for: .normal)
        assetTabbar.setTitleColor(UIColor.base05, for: .selected)
        assetTabbar.setSelectedItem(coinTabBar, animated: false)
        assetTabbar.tabBarDelegate = self
        assetTabbar.preferredLayoutStyle = .fixed
        assetTabbar.rippleColor = .transparency
        
        coinsLayer.alpha = 1
        nftsLayer.alpha = 0
    }
    
    func tabBarView(_ tabBarView: MDCTabBarView, didSelect item: UITabBarItem) {
        if (item.tag == 0) {
            coinsLayer.alpha = 1
            nftsLayer.alpha = 0
            
        } else if (item.tag == 1) {
            coinsLayer.alpha = 0
            nftsLayer.alpha = 1
        }
    }
    
    @objc func onAccountReady() {
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        accountLabel.text = cAccount.name
        if (cChainConfig is ChainSui) {
            dashBtnFaucet.isHidden = true
            chainLabel.text = ""
        } else {
            if (cChainConfig is ChainSuiDev) {
                chainLabel.text = "Devnet"
                
            } else if (cChainConfig is ChainSuiTest) {
                chainLabel.text = "Testnet"
            }
            dashBtnFaucet.isHidden = false
        }
    }
    
    @objc func onDataFetched() {
        let coinsCnt = DataManager.shared.suiBalances.filter { $0.0.contains(SUI_DENOM) == false }.count
        assetTabbar.items[0].title = "Coins (" + String(coinsCnt + 2) + ")"
        
        var suiNFTs = Array<JSON>()
        DataManager.shared.suiObjects.forEach { object in
            let typeS = object["type"].string?.lowercased()
            if (typeS?.contains("nft") == true && typeS?.contains("coin") == false) {
                suiNFTs.append(object)
            }
        }
        assetTabbar.items[1].title = "NFTs (" + String(suiNFTs.count) + ")"
    }
    
    @objc func onClickAccount() {
        let selectAccountSheet = SelectAccountSheet(nibName: "SelectAccountSheet", bundle: nil)
        selectAccountSheet.resultDelegate = self
        onStartSheet(selectAccountSheet)
    }
    
    
    @IBAction func onClickExplorer(_ sender: UIButton) {
        var urlString = "https://explorer.sui.io/address/" + cAccount.baseAddress!.address!
        if (cChainConfig is ChainSuiDev) {
            urlString = urlString + "?network=devnet"
        } else if (cChainConfig is ChainSuiTest) {
            urlString = urlString + "?network=testnet"
        }
        guard let url = URL(string: urlString) else { return }
        self.onStartSafariWeb(url)
    }
    
    func onClickAccountDetail() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            let accountListVC = AccountListVC(nibName: "AccountListVC", bundle: nil)
            accountListVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(accountListVC, animated: true)
        });
    }
    func onSelectAccount(_ account: BaseAccount) {
        if (account.id != self.cAccount.id) {
            BaseData.instance.setRecentAccount(account.id!)
            mainTab.updateState()
        }
    }

    @IBAction func onClickSend(_ sender: UIButton) {
        if (!checkEnoughFee(cChainConfig, .TxSend)) {
            onShowToast(NSLocalizedString("error_not_enough_gas_fee", comment: ""))
            return
        }
        let sendCoinVC = SendCoinVC(nibName: "SendCoinVC", bundle: nil)
        sendCoinVC.coinType = SUI_DENOM
        sendCoinVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sendCoinVC, animated: true)
    }
    
    @IBAction func onClickReceive(_ sender: UIButton) {
        let receiveVC = ReceiveVC(nibName: "ReceiveVC", bundle: nil)
        receiveVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(receiveVC, animated: true)
    }
    
    @IBAction func onClickFaucet(_ sender: UIButton) {
        self.onShowWait()
        Task {
            let result = await DataManager.shared.onFaucet(cAccount.baseAddress!.address!)
            print("result ", result)
            if (result != nil && result!["transferredGasObjects"].arrayValue.count > 0) {
                onShowToast(NSLocalizedString("faucet_success", comment: ""))
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5000), execute: {
                    self.onDismissWait()
                    DataManager.shared.loadAll()
                });
            } else {
                self.onDismissWait()
                onShowToast(NSLocalizedString("faucet_fail", comment: ""))
            }
        }
    }
    
    @IBAction func onClickStake(_ sender: UIButton) {
        let stakingInfoVC = StakingInfoVC(nibName: "StakingInfoVC", bundle: nil)
        stakingInfoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(stakingInfoVC, animated: true)
    }
}



