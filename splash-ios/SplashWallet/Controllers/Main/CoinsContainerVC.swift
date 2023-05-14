//
//  CoinsContainerVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/09.
//

import UIKit
import SwiftyJSON

class CoinsContainerVC: BaseVC {
    
    @IBOutlet weak var assetTable: UITableView!
    
    var mainTabVC: MainTab!
    var refresher: UIRefreshControl!
    var suiBalances = Array<(String, NSDecimalNumber)>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assetTable.delegate = self
        assetTable.dataSource = self
        assetTable.separatorStyle = .none
        assetTable.register(UINib(nibName: "AssetCell", bundle: nil), forCellReuseIdentifier: "AssetCell")
        assetTable.sectionHeaderTopPadding = 0
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(onRequestFetch), for: .valueChanged)
        refresher.tintColor = .base05
        assetTable.addSubview(refresher)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAccountReady), name: Notification.Name("AccountReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDataFetched), name: Notification.Name("DataFetched"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onMetadataFetched), name: Notification.Name("MetadataFetched"), object: nil)
        mainTabVC = ((self.parent)?.parent)?.parent as? MainTab
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AccountReady"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DataFetched"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("MetadataFetched"), object: nil)
        refresher.endRefreshing()
    }
    
    @objc func onRequestFetch() {
        mainTabVC.updateState(false)
    }
    
    @objc func onAccountReady() {
        suiBalances.removeAll()
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
    }
    
    @objc func onDataFetched() {
        refresher.endRefreshing()
        suiBalances.removeAll()
        DataManager.shared.suiBalances.forEach { balance in
            if (balance.0.contains(SUI_DENOM) == false) {
                suiBalances.append(balance)
            }
        }
        assetTable.reloadData()
    }
    
    @objc func onMetadataFetched() {
        assetTable.reloadData()
    }

}

extension CoinsContainerVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else {
            return suiBalances.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"AssetCell") as? AssetCell
        if (indexPath.section == 0) {
            cell?.onBindSuiBalance(cChainConfig, indexPath.row)
        } else {
            cell?.onBindBalance(cChainConfig, suiBalances[indexPath.row])
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                if (!checkEnoughFee(cChainConfig, .TxSend)) {
                    onShowToast(NSLocalizedString("error_not_enough_gas_fee", comment: ""))
                    return
                }
                let sendCoinVC = SendCoinVC(nibName: "SendCoinVC", bundle: nil)
                sendCoinVC.coinType = SUI_DENOM
                sendCoinVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(sendCoinVC, animated: true)
                
            } else {
                let stakingInfoVC = StakingInfoVC(nibName: "StakingInfoVC", bundle: nil)
                stakingInfoVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(stakingInfoVC, animated: true)
            }
            
        } else {
            if (!checkEnoughFee(cChainConfig, .TxSend)) {
                onShowToast(NSLocalizedString("error_not_enough_gas_fee", comment: ""))
                return
            }
            let sendCoinVC = SendCoinVC(nibName: "SendCoinVC", bundle: nil)
            sendCoinVC.coinType = suiBalances[indexPath.row].0
            sendCoinVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sendCoinVC, animated: true)
            
        }
        
    }
}

