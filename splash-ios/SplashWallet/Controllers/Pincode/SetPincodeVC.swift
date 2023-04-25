//
//  SetPincodeVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/15.
//

import UIKit
import LocalAuthentication

class SetPincodeVC: BaseVC {
    
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
    
    var stateImgViews: [UIImageView] = [UIImageView]()
    var pinBtns: [UIButton] = [UIButton]()
    
    var request: PincodeRequest!
    var firstInput = ""
    var secondInput = ""
    var isConfirmMode = false
    let authContext = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stateImgViews = [stateImgView0, stateImgView1, stateImgView2, stateImgView3]
        pinBtns = [pinBtn0, pinBtn1, pinBtn2, pinBtn3, pinBtn4, pinBtn5, pinBtn6, pinBtn7, pinBtn8, pinBtn9]
        pinMsgLabel.text = NSLocalizedString("init_pin", comment: "")
        onShuffleBtns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func onUpdateView() {
        if (isConfirmMode) {
            pinMsgLabel.text = NSLocalizedString("confirm_pin", comment: "")
            for (index, imgView) in stateImgViews.enumerated() {
                let dotImg = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
                imgView.image = dotImg
                if (index >= secondInput.count) {
                    imgView.tintColor = .base04
                } else {
                    imgView.tintColor = .base05
                }
            }
            
        } else {
            pinMsgLabel.text = NSLocalizedString("init_pin", comment: "")
            for (index, imgView) in stateImgViews.enumerated() {
                let dotImg = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
                imgView.image = dotImg
                if (index >= firstInput.count) {
                    imgView.tintColor = .base04
                } else {
                    imgView.tintColor = .base05
                }
            }
        }
    }
    
    func onValidate() {
        if (firstInput == secondInput) {
            onShowWait()
            if (BaseData.instance.setPinCode(secondInput)) {
                if (isBioSupport()) {
                    onShowBioAlert()
                } else {
                    onFinishSetPincode(.success)
                }
                
            } else {
                onFinishSetPincode(.fail)
            }
            
        } else {
            firstInput = ""
            secondInput = ""
            isConfirmMode = false
            onShuffleBtns()
            onUpdateView()
            onShowToast(NSLocalizedString("error_pin_not_matched", comment: ""))
        }
    }
    
    @IBAction func onClickNumber(_ sender: UIButton) {
        if (isConfirmMode) {
            secondInput = secondInput + (sender.titleLabel?.text)!
            if (secondInput.count == 4) {
                onValidate()
            }
            
        } else {
            firstInput = firstInput + (sender.titleLabel?.text)!
            if (firstInput.count == 4) {
                isConfirmMode = true
                onShuffleBtns()
            }
        }
        onUpdateView()
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        if (isConfirmMode) {
            if (secondInput.count == 0) {
                isConfirmMode = false
                onShuffleBtns()
            } else {
                secondInput = String(secondInput.prefix(secondInput.count - 1))
            }
            
        } else {
            if (firstInput.count > 0) {
                firstInput = String(firstInput.prefix(firstInput.count - 1))
            } else {
                onFinishSetPincode(.fail)
            }
        }
        onUpdateView()
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
    
    func onShowBioAlert() {
        var msg = ""
        var localMsg = ""
        if (authContext.biometryType == .faceID) {
            msg = NSLocalizedString("using_faceID", comment: "")
            localMsg = NSLocalizedString("faceID", comment: "")
        } else if (authContext.biometryType == .touchID) {
            msg = NSLocalizedString("using_touchID", comment: "")
            localMsg = NSLocalizedString("touchID", comment: "")
        }
        
        let alert = UIAlertController(title: "",
                                      message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localMsg) { (success, error) in
                if (success) {
                    print("success ", success)
                    BaseData.instance.setBioAuth(true)
                } else {
                    print("Error ", error)
                }
                DispatchQueue.main.async(execute: {
                    self.onFinishSetPincode(.success)
                });
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: { _ in
            DispatchQueue.main.async(execute: {
                self.onFinishSetPincode(.success)
            });
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onFinishSetPincode(_ result: PincodeResult) {
        self.resultDelegate?.pincodeResponse(request, result)
        if let navigationController = self.navigationController {
            navigationController.view.layer.add(moveoutAni(), forKey: kCATransition)
            navigationController.popViewController(animated: false)
        } else {
            self.dismiss(animated: true)
        }
    }
}

enum PincodeRequest: Int {
    case create = 0
    case simple = 1
    case checkMnemonic = 2
    case checkPrivateKey = 3
    case deleteAccount = 4
    case appLock = 5
    case introLock = 6
}

enum PincodeResult: Int {
    case fail = 0
    case success = 1
}

protocol PincodeDelegate {
    func pincodeResponse(_ request: PincodeRequest, _ result: PincodeResult)
}
