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
        mainTabVC = ((self.parent)?.parent)?.parent as? MainTab
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AccountReady"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DataFetched"), object: nil)
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
        suiBalances = DataManager.shared.suiBalances
        assetTable.reloadData()
    }

}

extension CoinsContainerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (suiBalances.count > 0) {
            return suiBalances.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"AssetCell") as? AssetCell
        if (suiBalances.count > 0) {
            cell?.onBindBalance(cChainConfig, suiBalances[indexPath.row])
        } else {
            cell?.onBindEmpty()
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!checkEnoughFee(cChainConfig)) {
            onShowToast(NSLocalizedString("error_not_enough_gas_fee", comment: ""))
            return
        }
        let sendCoinVC = SendCoinVC(nibName: "SendCoinVC", bundle: nil)
        sendCoinVC.balance = suiBalances[indexPath.row]
        sendCoinVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sendCoinVC, animated: true)
    }
}

