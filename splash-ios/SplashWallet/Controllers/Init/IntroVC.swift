//
//  IntroVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/15.
//

import UIKit
import Lottie

class IntroVC: BaseVC, BaseSheetDelegate, PincodeDelegate {
    
    @IBOutlet weak var lottieView: LottieAnimationView!
    @IBOutlet weak var createBtn: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theme = Theme.getThemes()[BaseData.instance.getTheme()].themeStyle
        if (theme == .dark) {
            lottieView.animation = LottieAnimation.named("dark")
        } else if (theme == .light) {
            lottieView.animation = LottieAnimation.named("light")
        } else {
            let systemTheme = UIScreen.main.traitCollection.userInterfaceStyle
            if (systemTheme == .dark) {
                lottieView.animation = LottieAnimation.named("dark")
            }
        }
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .playOnce
        lottieView.animationSpeed = 1.3
        lottieView.play(completion:  { _ in
            self.onCheckInitApp()
        })
    }
    
    override func setLocalizedString() {
        createBtn.setTitle(NSLocalizedString("start", comment: ""), for: .normal)
    }
    
    func onCheckInitApp() {
        let accounts = BaseData.instance.selectAccounts()
        if (accounts.count > 0 && BaseData.instance.getRecentAccount() != nil) {
            onCheckPincode()
        } else {
            createBtn.isHidden = false
        }
    }
    
    func onCheckPincode() {
        if BaseData.instance.isRequiredUnlock() {
            let pinVC = PincodeVC(nibName: "PincodeVC", bundle: nil)
            pinVC.request = .introLock
            pinVC.resultDelegate = self
            self.navigationController!.view.layer.add(self.moveinAni(), forKey: kCATransition)
            self.navigationController?.pushViewController(pinVC, animated: false)
            
        } else {
            onStartMainTab()
        }
    }
    
    
    func pincodeResponse(_ request: PincodeRequest, _ result: PincodeResult) {
        if (result == .success) {
            onStartMainTab()
        }
    }
    
    @IBAction func onClickCreate(_ sender: UIButton) {
        let baseSheet = BaseSheet(nibName: "BaseSheet", bundle: nil)
        baseSheet.sheetResult = self
        baseSheet.sheetType = .SelectNewAccount
        onStartSheet(baseSheet)
    }
    
    func onSelectSheet(_ sheetType: SheetType?, _ result: BaseSheetResult) {
        print("onSelectSheet ", sheetType)
        if (sheetType == .SelectNewAccount) {
            if (result.position == 0) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.onNextVc(.create)
                });
                
            } else if (result.position == 1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.onNextVc(.mnemonc)
                });
                
            } else if (result.position == 2) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.onNextVc(.privateKey)
                });
            }
        }
    }
    
    func onNextVc(_ type: NewAccountType) {
        let createNameVC = CreateNameVC(nibName: "CreateNameVC", bundle: nil)
        createNameVC.newAccountType = type
        print("onNextVc ", self.navigationController)
        self.navigationController?.pushViewController(createNameVC, animated: true)
    }
}
