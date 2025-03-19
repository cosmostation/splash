//
//  MainTabViewController.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/01/07.
//

import UIKit
import SuiSwift

class MainTab: UITabBarController, UITabBarControllerDelegate {
    private var hasPresentedSheet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = Theme.getThemes()[BaseData.instance.getTheme()].themeStyle
        
        self.delegate = self
        self.updateState()
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1))
        lineView.backgroundColor = .base03
        tabBar.addSubview(lineView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasPresentedSheet {
            if let navController = selectedViewController as? UINavigationController {
                let currentVC = navController.topViewController
                let sheet = InfoPopUpSheet(nibName: "InfoPopUpSheet", bundle: nil)
                sheet.viewController = currentVC
                sheet.modalPresentationStyle = .overFullScreen
                currentVC?.present(sheet, animated: true)
                hasPresentedSheet = true
            }
        }
    }

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (tabBarController.viewControllers?.firstIndex(of: viewController) == 1) {
            let dappVC = DappVC(nibName: "DappVC", bundle: nil)
            dappVC.dappURL = "https://dapps.splash.im"
            dappVC.hidesBottomBarWhenPushed = true
            if let navigation = tabBarController.selectedViewController as? UINavigationController {
                navigation.pushViewController(dappVC, animated: true)
            }
            return false
        }
        return true
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
//                print("currectAccount ", currectAccount?.baseAddress?.chain , " ", currectAccount?.baseAddress?.address)
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
