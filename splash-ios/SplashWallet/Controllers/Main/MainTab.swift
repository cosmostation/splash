//
//  MainTabViewController.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/01/07.
//

import UIKit
import SuiSwift

class MainTab: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = Theme.getThemes()[BaseData.instance.getTheme()].themeStyle
        
        self.updateState()
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1))
        lineView.backgroundColor = .base03
        tabBar.addSubview(lineView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAccountReady), name: Notification.Name("AccountReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDataFetched), name: Notification.Name("DataFetched"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AccountReady"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DataFetched"), object: nil)
    }
    
    public func updateState(_ showWait: Bool? = true) {
        if (showWait == true) { self.onShowWait() }
        Task {
            let recentChain = BaseData.instance.getRecentChain()
            if let recentAccount = BaseData.instance.getRecentAccount() {
                let currectAccount = await recentAccount.prepareAccount(recentChain)
                print("currectAccount ", currectAccount?.baseAddress?.chain , " ", currectAccount?.baseAddress?.address)
                DataManager.shared.account = currectAccount
                DataManager.shared.loadAll()
                NotificationCenter.default.post(name: Notification.Name("AccountReady"), object: nil, userInfo: nil)
            }
        }
    }
    
    @objc func onAccountReady() {
        print("MainTab onAccountReady")
    }
    
    @objc func onDataFetched() {
        self.onDismissWait()
        DataManager.shared.openDappVCAction?()
        DataManager.shared.openDappVCAction = nil
    }
}
