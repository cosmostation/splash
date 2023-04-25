//
//  PincodeVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/15.
//

import UIKit
import LocalAuthentication

class PincodeVC: BaseVC {
    
    var resultDelegate: PincodeDelegate?
    
    var nums: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    @IBOutlet weak var pinMsgLabel: UILabel!
    @IBOutlet weak var stateImgView0: UIImageView!
    @IBOutlet weak var stateImgView1: UIImageView!
    @IBOutlet weak var stateImgView2: UIImageView!
    @IBOutlet weak var stateImgView3: UIImageView!
    
    @IBOutlet weak var pinBtn0: UIButton!
    @IBOutlet weak var pinBtn1: UIButton!
    @IBOutlet weak var pinBtn2: UIButton!
    @IBOutlet weak var pinBtn3: UIButton!
    @IBOutlet weak var pinBtn4: UIButton!
    @IBOutlet weak var pinBtn5: UIButton!
    @IBOutlet weak var pinBtn6: UIButton!
    @IBOutlet weak var pinBtn7: UIButton!
    @IBOutlet weak var pinBtn8: UIButton!
    @IBOutlet weak var pinBtn9: UIButton!
    @IBOutlet weak var bioBtn: UIButton!
    
    var stateImgViews: [UIImageView] = [UIImageView]()
    var pinBtns: [UIButton] = [UIButton]()
    
    var request: PincodeRequest!
    var userInput = ""
    let authContext = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        stateImgViews = [stateImgView0, stateImgView1, stateImgView2, stateImgView3]
        pinBtns = [pinBtn0, pinBtn1, pinBtn2, pinBtn3, pinBtn4, pinBtn5, pinBtn6, pinBtn7, pinBtn8, pinBtn9]
        onShuffleBtns()
        
        if (isBioSupport() == true && BaseData.instance.getBioAuth()) {
            if (authContext.biometryType == .faceID) {
                bioBtn.setImage(UIImage(systemName: "faceid"), for: .normal)
            } else if (authContext.biometryType == .touchID) {
                bioBtn.setImage(UIImage(systemName: "touchid"), for: .normal)
            } else {
                bioBtn.setImage(nil, for: .normal)
            }
        } else {
            bioBtn.setImage(nil, for: .normal)
        }
        onCheckBioAuth()
    }
    
    override func setLocalizedString() {
        pinMsgLabel.text = NSLocalizedString("enter_pin", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onCheckBioAuthForce), name: Notification.Name("AppForeGround"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AppForeGround"), object: nil)
    }
    
    func onUpdateView() {
        for (index, imgView) in stateImgViews.enumerated() {
            let dotImg = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
            imgView.image = dotImg
            if (index >= userInput.count) {
                imgView.tintColor = .base04
            } else {
                imgView.tintColor = .base05
            }
        }
    }
    
    func onValidate() {
        if (userInput == BaseData.instance.getPinCode()) {
            onFinishCheckPincode(.success)
            
        } else {
            userInput = ""
            onShowToast(NSLocalizedString("error_invalid_pin", comment: ""))
            onUpdateView()
        }
    }
    
    @IBAction func onClickNumber(_ sender: UIButton) {
        userInput = userInput + (sender.titleLabel?.text)!
        if (userInput.count == 4) {
            onValidate()
        }
        onUpdateView()
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        if (userInput.count > 0) {
            userInput = String(userInput.prefix(userInput.count - 1))
            onUpdateView()
        } else {
            if (request == .introLock || request == .appLock) {
                onShowToast(NSLocalizedString("input_valid_pin", comment: ""))
            } else {
                onFinishCheckPincode(.fail)
            }
        }
    }
    
    @IBAction func onClickBio(_ sender: UIButton) {
        onCheckBioAuthForce()
    }
    
    func onShuffleBtns() {
        nums.shuffle()
        for (index, btn) in pinBtns.enumerated() {
            btn.setTitle(nums[index], for: .normal)
        }
    }
    
    func isBioSupport() -> Bool {
        return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func onCheckBioAuth() {
        if (BaseData.instance.getBioAuth() == false || isBioSupport() == false || request == .appLock) {
            return
        }
        onBioAuth()
    }
    
    @objc func onCheckBioAuthForce() {
        if (BaseData.instance.getBioAuth() == false || isBioSupport() == false) {
            return
        }
        onBioAuth()
    }
    
    func onBioAuth() {
        var localMsg = ""
        if (authContext.biometryType == .faceID) {
            localMsg = NSLocalizedString("faceID", comment: "")
        } else if (authContext.biometryType == .touchID) {
            localMsg = NSLocalizedString("touchID", comment: "")
        }
        self.authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localMsg) { (success, error) in
            if (success) {
                DispatchQueue.main.async(execute: {
                    self.onFinishCheckPincode(.success)
                });
            }
        }
    }
    
    func onFinishCheckPincode(_ result: PincodeResult) {
        self.resultDelegate?.pincodeResponse(request, result)
        if let navigationController = self.navigationController {
            navigationController.view.layer.add(moveoutAni(), forKey: kCATransition)
            navigationController.popViewController(animated: false)
        } else {
            self.dismiss(animated: true)
        }
    }

}
