//
//  StakingInfoVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/17.
//

import UIKit
import SwiftyJSON
import SuiSwift

class StakingInfoVC: BaseVC {
    
    @IBOutlet weak var stakeInfoTableview: UITableView!
    var refresher: UIRefreshControl!
    
    var suiStaked = Array<JSON>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        
        stakeInfoTableview.delegate = self
        stakeInfoTableview.dataSource = self
        stakeInfoTableview.separatorStyle = .none
        stakeInfoTableview.register(UINib(nibName: "StakeInfoTimerCell", bundle: nil), forCellReuseIdentifier: "StakeInfoTimerCell")
        stakeInfoTableview.register(UINib(nibName: "StakeInfoUnstakeCell", bundle: nil), forCellReuseIdentifier: "StakeInfoUnstakeCell")
        stakeInfoTableview.register(UINib(nibName: "StakeInfoStakeCell", bundle: nil), forCellReuseIdentifier: "StakeInfoStakeCell")
        stakeInfoTableview.sectionHeaderTopPadding = 0
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(onRequestFetch), for: .valueChanged)
        refresher.tintColor = .base05
        stakeInfoTableview.addSubview(refresher)
        
        onFetchStakeInfo()
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_staking_info", comment: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refresher.endRefreshing()
    }
    
    func onUpdateView() {
        stakeInfoTableview.reloadData()
    }
    
    @objc func onRequestFetch() {
        onFetchStakeInfo(false)
    }
    
    func onFetchStakeInfo(_ showWait: Bool? = true) {
        if (showWait == true) { self.onShowWait() }
        let group = DispatchGroup()
        group.enter()
        let getStakesParams = JsonRpcRequest("suix_getStakes", JSON(arrayLiteral: cAccount.baseAddress?.address))
        SuiClient.shared.SuiRequest(getStakesParams) { stakes, error in
            stakes?.arrayValue.forEach({ stake in
                self.suiStaked.append(stake)
            })
            self.onDismissWait()
            self.onUpdateView()
            group.leave()
        }
    }
    
    func onStartStake() {
        if let suiBalance = DataManager.shared.suiBalances.filter({ $0.0.contains(SUI_DENOM) }).first {
            let txFee = BaseData.instance.getSuiFee(cChainConfig, .TxSend)
            let stakeThreshold = NSDecimalNumber(string: "1000000000")
            if (suiBalance.1.compare(txFee.adding(stakeThreshold)).rawValue < 0) {
                self.onShowToast(NSLocalizedString("error_not_enough_stake", comment: ""))
                return
            }
            let stakeVC = StakeVC(nibName: "StakeVC", bundle: nil)
            self.navigationController?.pushViewController(stakeVC, animated: true)
        }
    }
    
    func onStartUnstake() {
        let unstakeVC = UnstakeVC(nibName: "UnstakeVC", bundle: nil)
        unstakeVC.suiStaked = suiStaked
        self.navigationController?.pushViewController(unstakeVC, animated: true)
    }
}

extension StakingInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 1) {
            if (suiStaked.count <= 0) { return 0 }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"StakeInfoTimerCell") as? StakeInfoTimerCell
            cell?.onBindView()
            cell?.actionRefresh = { self.onFetchStakeInfo() }
            return cell!
            
        } else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"StakeInfoUnstakeCell") as? StakeInfoUnstakeCell
            cell?.onBindView(suiStaked)
            cell?.actionUnStake = { self.onStartUnstake() }
            return cell!
            
        } else if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"StakeInfoStakeCell") as? StakeInfoStakeCell
            cell?.onBindView()
            cell?.actionStake = { self.onStartStake() }
            return cell!
        }
        return UITableViewCell()
    }
    
}
