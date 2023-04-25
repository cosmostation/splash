//
//  RenameSheet.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/03.
//

import UIKit
import MaterialComponents

class RenameSheet: BaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var confirmBtn: BaseButton!
    @IBOutlet weak var renameAccountTitle: UILabel!
    @IBOutlet weak var accountNameTextField: MDCOutlinedTextField!
    
    var toUpdateAccount: BaseAccount!
    var resultDelegate: RenameDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        accountNameTextField.setup()
        accountNameTextField.text = toUpdateAccount.name
        accountNameTextField.delegate = self
    }
    
    override func setLocalizedString() {
        renameAccountTitle.text = NSLocalizedString("vc_title_rename_account", comment: "")
        accountNameTextField.label.text = NSLocalizedString("account_name", comment: "")
        accountNameTextField.placeholder = NSLocalizedString("insert_account_name", comment: "")
        confirmBtn.setTitle(NSLocalizedString("confirm", comment: ""), for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == accountNameTextField) {
            textField.resignFirstResponder()
        }
        return true
    }

    @IBAction func onClickConfirm(_ sender: UIButton) {
        let userInput = accountNameTextField.text?.trimmingCharacters(in: .whitespaces)
        if (userInput?.isEmpty == true) {
            onShowToast(NSLocalizedString("error_account_name", comment: ""))
            return
        }
        if (userInput != toUpdateAccount.name) {
            if (BaseData.instance.selectAccounts().filter({ $0.name == userInput }).first != nil) {
                onShowToast(NSLocalizedString("error_alreay_exist_account_name", comment: ""))
                return
            }
            toUpdateAccount.name = userInput
            BaseData.instance.updateAccount(toUpdateAccount)
            resultDelegate?.onRenamed()
            dismiss(animated: true)
        }
    }
}

protocol RenameDelegate {
    func onRenamed()
}
