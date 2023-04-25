//
//  DeleteAccountSheet.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/03.
//

import UIKit

class DeleteAccountSheet: BaseVC {
    
    @IBOutlet weak var deleteBtn: RedButton!
    @IBOutlet weak var deleteAccountTitle: UILabel!
    @IBOutlet weak var deleteMsgLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var toDeleteAccount: BaseAccount!
    var resultDelegate: DeleteDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cChainConfig = DataManager.shared.account?.chainConfig
        nameLabel.text = toDeleteAccount.name
        Task {
            if let toDeleteAddress = await toDeleteAccount.getBaseAddress(cChainConfig) {
                addressLabel.text = toDeleteAddress.address
            }
        }
    }
    
    override func setLocalizedString() {
        deleteAccountTitle.text = NSLocalizedString("vc_title_delete_account", comment: "")
        deleteBtn.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)
        deleteMsgLabel.text = NSLocalizedString("mnemonic_delete", comment: "")
    }

    @IBAction func onClickDelete(_ sender: UIButton) {
        resultDelegate?.onRequestDeleted()
        dismiss(animated: true)
    }
}

protocol DeleteDelegate {
    func onRequestDeleted()
}
