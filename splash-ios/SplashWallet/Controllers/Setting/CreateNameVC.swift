//
//  CreateNameVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/15.
//

import UIKit
import MaterialComponents

class CreateNameVC: BaseVC, PincodeDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nextBtn: BaseButton!
    @IBOutlet weak var accountNameTextField: MDCOutlinedTextField!
    
    var newAccountType: NewAccountType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onCheckPinCodeInited()
        accountNameTextField.setup()
        accountNameTextField.delegate = self
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_set_account_name", comment: "")
        accountNameTextField.label.text = NSLocalizedString("account_name", comment: "")
//        accountNameTextField.placeholder = NSLocalizedString("insert_account_name", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == accountNameTextField) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func onClickNext(_ sender: UIButton?) {
        let userInput = accountNameTextField.text?.trimmingCharacters(in: .whitespaces)
        if (onValidate(userInput)) {
            if (newAccountType == .create) {
                let createMnemonicVC = CreateMnemonicVC(nibName: "CreateMnemonicVC", bundle: nil)
                createMnemonicVC.accountName = userInput
                self.navigationController?.title = NSLocalizedString("vc_title_create_mnemonic", comment: "")
                self.navigationController?.pushViewController(createMnemonicVC, animated: true)

            } else if (newAccountType == .privateKey) {
                let importPrivKeyVC = ImportPrivKeyVC(nibName: "ImportPrivKeyVC", bundle: nil)
                importPrivKeyVC.accountName = userInput
                self.navigationController?.pushViewController(importPrivKeyVC, animated: true)

            } else if (newAccountType == .mnemonc) {
                let importMnemonicVC = ImportMnemonicVC(nibName: "ImportMnemonicVC", bundle: nil)
                importMnemonicVC.accountName = userInput
                self.navigationController?.pushViewController(importMnemonicVC, animated: true)
            }
        }
    }
    
    func onValidate(_ userInput: String?) -> Bool {
        if (userInput?.isEmpty == true) {
            onShowToast(NSLocalizedString("error_account_name", comment: ""))
            return false
        }
        if (BaseData.instance.selectAccounts().filter({ $0.name == userInput }).first != nil) {
            onShowToast(NSLocalizedString("error_alreay_exist_account_name", comment: ""))
            return false
        }
        return true
    }
    
    func onCheckPinCodeInited() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            if (BaseData.instance.hasPinCode()) {
                let pinVC = PincodeVC(nibName: "PincodeVC", bundle: nil)
                pinVC.request = .simple
                pinVC.resultDelegate = self
                self.navigationController!.view.layer.add(self.moveinAni(), forKey: kCATransition)
                self.navigationController?.pushViewController(pinVC, animated: false)
                
            } else {
                let setPinVC = SetPincodeVC(nibName: "SetPincodeVC", bundle: nil)
                setPinVC.request = .create
                setPinVC.resultDelegate = self
                self.navigationController!.view.layer.add(self.moveinAni(), forKey: kCATransition)
                self.navigationController?.pushViewController(setPinVC, animated: false)
            }
        });
    }
    
    
    func pincodeResponse(_ request: PincodeRequest, _ result: PincodeResult) {
        if (result == .success) {
            self.view.isUserInteractionEnabled = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.navigationController?.popViewController(animated: true)
            });
        }
    }
}

enum NewAccountType: Int {
    case create = 0
    case privateKey = 1
    case mnemonc = 2
}
