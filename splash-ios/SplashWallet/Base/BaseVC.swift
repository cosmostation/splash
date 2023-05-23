//
//  BaseVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/16.
//

import UIKit
import Toast
import SwiftyJSON
import SafariServices
import SuiSwift

class BaseVC: UIViewController {
    
    var cAccount: BaseAccount!
    var cChainConfig: ChainConfig!

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = Theme.getThemes()[BaseData.instance.getTheme()].themeStyle
        navigationController?.navigationBar.overrideUserInterfaceStyle = Theme.getThemes()[BaseData.instance.getTheme()].themeStyle
        Bundle.setLanguage(Language.getLanguages()[BaseData.instance.getLanguage()].languageCode)
        setNavigationBar()
        setKeyboardHideGesture()
        setLocalizedString()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setLocalizedString() { }
    
    func moveinAni() -> CAAnimation{
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        return transition
    }
    
    func moveoutAni() -> CAAnimation{
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        return transition
    }
    
    func onStartIntro() {
        let IntroVC = UIStoryboard(name: "Init", bundle: nil).instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
        let rootVC = UINavigationController(rootViewController: IntroVC)
        UIApplication.shared.windows.first?.rootViewController = rootVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func onStartMainTab(_ ani: Bool = true) {
        let mainTab = UIStoryboard(name: "MainTab", bundle: nil).instantiateViewController(withIdentifier: "MainTab") as! MainTab
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainTab
        present(mainTab, animated: ani, completion: nil)
    }
    
    func onStartSheet(_ baseSheet: BaseVC, _ height: CGFloat? = 320) {
        guard let sheet = baseSheet.presentationController as? UISheetPresentationController else {
            return
        }
        if #available(iOS 16.0, *) {
            sheet.detents = [
                .custom { _ in return height },
                .custom { context in return context.maximumDetentValue * 0.6 }
            ]
        } else {
            sheet.detents = [.medium()]
        }
        sheet.largestUndimmedDetentIdentifier = .large
        sheet.prefersGrabberVisible = true
        present(baseSheet, animated: true)
    }
    
    func onStartTxResult(_ result: JSON?) {
        let txResultVC = TxResultVC(nibName: "TxResultVC", bundle: nil)
        txResultVC.TxResult = result
        self.navigationController?.pushViewController(txResultVC, animated: true)
    }
    
    func onStartSafariWeb(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .popover
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = safariViewController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                present(safariViewController, animated: true, completion: nil)
            }
        } else {
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    
    func checkEnoughFee(_ chainConfig: ChainConfig, _ type: TxCheckSheetType) -> Bool {
        if let suiBalance = DataManager.shared.suiBalances.filter({ $0.0.contains(SUI_DENOM) }).first {
            let available = suiBalance.1
            let fee = BaseData.instance.getSuiFee(chainConfig, type)
            if (available.compare(fee).rawValue > 0) {
                return true
            }
        }
        return false
    }
    
    func getFeeObjectId() -> String {
        var result = ""
        var amount = NSDecimalNumber.zero
        DataManager.shared.suiObjects.forEach { object in
            let type = object["type"].stringValue
            if (type.contains(SUI_DENOM)) {
                let newAmount = NSDecimalNumber.init(string:  object["content"]["fields"]["balance"].stringValue)
                if (newAmount.compare(amount).rawValue > 0) {
                    amount = newAmount
                    result = object["objectId"].stringValue
                }
            }
        }
        return result
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNavigationBar()
    }
    
    
    func onExcuteSuiTx(_ result: JSON?, _ error: JSON?) {
        let privKey = self.cAccount.privateKey!
        let pubkey = self.cAccount.publicKey!
        
        guard let txByteS = result?["txBytes"].stringValue, let txBytes = Data(base64Encoded: txByteS) else {
            if let error = error {
                print("txBytes error ", error)
                self.onShowToast(NSLocalizedString("error_tx", comment: "") + error.description)
                self.onDismissWait()
            }
            return
        }
        
        let signedData = SuiClient.shared.sign(privKey, Data([0, 0, 0]) + txBytes)
        SuiClient.shared.executeTransaction(txBytes, signedData, pubkey, ["showEffects": true]) { result, error in
            print("execute result ", result)
            guard let result = result else {
                if let error = error {
                    print("execute error ", error)
                    self.onShowToast(NSLocalizedString("error_tx", comment: "") + error.description)
                    self.onDismissWait()
                }
                return
            }
            self.onStartTxResult(result)
        }
    }
}


extension UIViewController {
    /**
     Shows a toast on the specified UIView
     
     - Parameter text: text to be displayed
     - Parameter onView: view where the toast will be displayed, if not provided the view of the UIViewController will be used
     */
    func onShowToast(_ text: String, onView targetView: UIView? = nil) {
        var style = ToastStyle()
        style.backgroundColor = UIColor.gray
        if let targetView = targetView {
            targetView.makeToast(text, duration: 2.0, position: .bottom, style: style)
        } else {
            view.makeToast(text, duration: 2.0, position: .bottom, style: style)
        }
    }
    
    func onShowWait() {
        view.makeToastActivity(.center)
        view.isUserInteractionEnabled = false
    }
    
    func onDismissWait() {
        view.hideToastActivity()
        view.isUserInteractionEnabled = true
    }
    
    func setKeyboardHideGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setNavigationBar() {
        let naviBackBtn = UIImage(named: "navi_back")?.withRenderingMode(.alwaysOriginal).withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -8.0, bottom: 0.0, right: -2.0))
        let naviBackBtnLight = UIImage(named: "navi_back_light")?.withRenderingMode(.alwaysOriginal).withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -8.0, bottom: 0.0, right: -2.0))
        let naviBackBtnDark = UIImage(named: "navi_back_dark")?.withRenderingMode(.alwaysOriginal).withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -8.0, bottom: 0.0, right: -2.0))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titlePositionAdjustment = .init(
           horizontal: -CGFloat.greatestFiniteMagnitude,
           vertical: 0
        )
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.base05,
            .font: font2
        ]
        
        if (overrideUserInterfaceStyle == .light) {
            appearance.setBackIndicatorImage(naviBackBtnLight, transitionMaskImage: naviBackBtnLight)
        } else if (overrideUserInterfaceStyle == .dark) {
            appearance.setBackIndicatorImage(naviBackBtnDark, transitionMaskImage: naviBackBtnDark)
        } else {
            appearance.setBackIndicatorImage(naviBackBtn, transitionMaskImage: naviBackBtn)
        }
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.standardAppearance = appearance
    }
}


extension Bundle {
    class func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
    #endif
}
