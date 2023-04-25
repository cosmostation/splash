//
//  AccountSwitchCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/02.
//

import UIKit

class AccountSwitchCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    var actionRename: (() -> Void)? = nil
    var actionDelete: (() -> Void)? = nil
    var actionMnemonic: (() -> Void)? = nil
    var actionPrivateKey: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.addressLabel.text = ""
    }
    
    func onBindAccount(_ chainConfig: ChainConfig?, _ baseAccount: BaseAccount) {
        nameLabel.text = baseAccount.name
        Task {
            if let baseAccount = await baseAccount.getBaseAddress(chainConfig!) {
                addressLabel.text = baseAccount.address
            }
        }
        
        
        
        editBtn.showsMenuAsPrimaryAction = true
        let rename = UIAction(title: NSLocalizedString("rename", comment: ""), image: nil, handler: { _ in
            self.actionRename?()
        })
        let delete = UIAction(title: NSLocalizedString("delete", comment: ""), image: nil, handler: { _ in
            self.actionDelete?()
        })
        let mnemonic = UIAction(title: NSLocalizedString("view_mnemonic", comment: ""), image: nil, handler: { _ in
            self.actionMnemonic?()
        })
        let privateKey = UIAction(title: NSLocalizedString("view_private_key", comment: ""), image: nil, handler: { _ in
            self.actionPrivateKey?()
        })
        if (baseAccount.withMenmonic == true) {
            editBtn.menu = UIMenu(title: "",
                                  image: nil,
                                  identifier: nil,
                                  options: .displayInline,
                                  children: [rename, delete, mnemonic, privateKey])
            
        } else {
            editBtn.menu = UIMenu(title: "",
                                  image: nil,
                                  identifier: nil,
                                  options: .displayInline,
                                  children: [rename, delete, privateKey])
            
        }
    }
}
