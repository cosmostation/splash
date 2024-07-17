//
//  ImportPrivKeyVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/22.
//

import UIKit
import MaterialComponents
import Web3Core

class ImportPrivKeyVC: BaseVC, UITextViewDelegate {
    
    @IBOutlet weak var nextBtn: BaseButton!
    @IBOutlet weak var privKeyTextArea: MDCOutlinedTextArea!
    
    var accountName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        privKeyTextArea.setup()
        privKeyTextArea.textView.delegate = self
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_import_private_key", comment: "")
        privKeyTextArea.label.text = NSLocalizedString("private_key", comment: "")
//        privKeyTextArea.placeholder = NSLocalizedString("insert_private_key", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == privKeyTextArea.textView) {
            if (text == "\n") {
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
    @IBAction func onClickNext(_ sender: UIButton) {
        let userInput = privKeyTextArea.textView.text.trimmingCharacters(in: .whitespaces)
        if (onValidate(userInput)) {
            onRestoreAccount(accountName, userInput)
        } else {
            onShowToast(NSLocalizedString("error_invalid_privatekey", comment: ""))
        }
    }
    
    func onValidate(_ userInput: String?) -> Bool {
        guard userInput != nil else { return false }
        guard let privateKeyData = Data.fromHex(userInput!) else { return false }
        guard SECP256K1.verifyPrivateKey(privateKey: privateKeyData) else { return false }
        return true
    }
    
    func onRestoreAccount(_ name: String, _ privKey: String) {
        onShowWait()
        DispatchQueue.global().async {
            let restoreAccount = BaseAccount.init(uuid: UUID().uuidString, name: name,
                                                  withMenmonic: false, time: Date().millisecondsSince1970, favo: false, mnemonic: "")
            let result = BaseData.instance.insertAccount(restoreAccount)
            if let account = BaseData.instance.selectAccountById(result) {
                BaseData.instance.setPrivateKey(account.uuid!, privKey)
                BaseData.instance.setRecentAccount(account.id!)
                DispatchQueue.main.async(execute: {
                    self.onDismissWait()
                    self.onStartMainTab()
                });
            }
        }
    }
}
