//
//  MainTabActivity.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/01/07.
//

import UIKit
import SwiftyJSON

class MainTabActivity: BaseVC {
    
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var mainTabVC: MainTab!
    var refresher: UIRefreshControl!
    var group = Array<HistoryGroup>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityTable.delegate = self
        activityTable.dataSource = self
        activityTable.separatorStyle = .none
        activityTable.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
        activityTable.sectionHeaderTopPadding = 0
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(onRequestFetch), for: .valueChanged)
        refresher.tintColor = .base05
        activityTable.addSubview(refresher)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onHistoryFetched), name: Notification.Name("HistoryFetched"), object: nil)
        mainTabVC = (self.parent)?.parent as? MainTab
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        DataManager.shared.onFetchHistory(cAccount.baseAddress?.address ?? "")
        onUpdateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("HistoryFetched"), object: nil)
        refresher.endRefreshing()
    }
    
    func onUpdateView() {
        group.removeAll()
        DataManager.shared.suiTxs.forEach { json in
            let date = TimeUtils.getDay(json["timestampMs"].intValue)
            var matched = -1
            for i in 0 ..< group.count {
                if (group[i].date == date) {
                    matched = i
                }
            }
            if (matched >= 0) {
                var updated = group[matched].values
                updated.append(json)
                group[matched].values = updated

            } else {
                group.append(HistoryGroup.init(date, [json]))
            }
        }
        
        if (group.count > 0) {
            activityTable.reloadData()
            emptyView.isHidden = true
        } else {
            emptyView.isHidden = false
        }
    }
    
    @objc func onRequestFetch() {
        mainTabVC.updateState(false)
    }
    
    @objc func onAccountReady() {
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
    }
    
    @objc func onHistoryFetched() {
        print("onHistoryFetched")
        refresher.endRefreshing()
        onUpdateView()
    }

}

extension MainTabActivity: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ActivityHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let today = TimeUtils.getDay(Int(Date().timeIntervalSince1970) * 1000)
        if (group[section].date == today) {
            view.titleLabel.text = "Today"
        } else {
            view.titleLabel.text = group[section].date
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return group.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group[section].values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ActivityCell") as? ActivityCell
        cell?.onBindActivity(cAccount.baseAddress?.address, group[indexPath.section].values[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = group[indexPath.section].values[indexPath.row]
        var urlString = "https://explorer.sui.io/txblock/" + history["digest"].stringValue
        if (cChainConfig is ChainSuiDev) {
            urlString = urlString + "?network=devnet"
        } else if (cChainConfig is ChainSuiTest) {
            urlString = urlString + "?network=testnet"
        }
        guard let url = URL(string: urlString) else { return }
        self.onStartSafariWeb(url)
    }
    
}

struct HistoryGroup {
    var date : String!
    var values = Array<JSON>()
    
    init(_ date: String!, _ values: Array<JSON>) {
        self.date = date
        self.values = values
    }
}
