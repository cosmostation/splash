//
//  ImportMnemonicVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/22.
//

import UIKit
import MaterialComponents
import Web3Core

class ImportMnemonicVC: BaseVC, UITextViewDelegate {
    
    @IBOutlet weak var nextBtn: BaseButton!
    @IBOutlet weak var mnemonicTextArea: MDCOutlinedTextArea!
    
    var accountName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mnemonicTextArea.setup()
        mnemonicTextArea.textView.delegate = self
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_import_mnemonic", comment: "")
        mnemonicTextArea.label.text = NSLocalizedString("mnemonic_phrases", comment: "")
//        mnemonicTextArea.placeholder = NSLocalizedString("insert_mnemonic_phrases", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == mnemonicTextArea.textView) {
            if (text == "\n") {
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
    @IBAction func onClickNext(_ sender: UIButton) {
        let userInput = mnemonicTextArea.textView.text.trimmingCharacters(in: .whitespaces)
        if (onValidate(userInput)) {
            onRestoreAccount(accountName, userInput)
        } else {
            onShowToast(NSLocalizedString("error_invalid_menmonic", comment: ""))
        }
    }
    
    func onValidate(_ userInput: String?) -> Bool {
        guard userInput != nil else { return false }
        guard BIP39.seedFromMmemonics(userInput!, password: "", language: .english) != nil else { return false }
        return true
    }
    
    func onRestoreAccount(_ name: String, _ mnemonic: String) {
        onShowWait()
        DispatchQueue.global().async {
            let restoreAccount = BaseAccount.init(uuid: UUID().uuidString, name: name,
                                                  withMenmonic: true, time: Date().millisecondsSince1970, favo: false, mnemonic: mnemonic)
            let result = BaseData.instance.insertAccount(restoreAccount)
            if let account = BaseData.instance.selectAccountById(result) {
                BaseData.instance.setMnemonic(account.uuid!, mnemonic)
                BaseData.instance.setRecentAccount(account.id!)
                DispatchQueue.main.async(execute: {
                    self.onDismissWait()
                    self.onStartMainTab()
                });
            }
        }
    }
}
