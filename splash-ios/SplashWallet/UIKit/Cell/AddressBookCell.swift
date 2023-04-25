//
//  AddressBookCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/13.
//

import UIKit

class AddressBookCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    var actionEdit: (() -> Void)? = nil
    var actionDelete: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func onBindAddress(_ chainConfig: ChainConfig?, _ addressBook: AddressBook) {
        nameLabel.text = addressBook.name
        addressLabel.text = addressBook.address
        
        editBtn.showsMenuAsPrimaryAction = true
        let edit = UIAction(title: NSLocalizedString("edit", comment: ""), image: nil, handler: { _ in
            self.actionEdit?()
        })
        let delete = UIAction(title: NSLocalizedString("delete", comment: ""), image: nil, handler: { _ in
            self.actionDelete?()
        })
        editBtn.menu = UIMenu(title: "",
                              image: nil,
                              identifier: nil,
                              options: .displayInline,
                              children: [edit, delete])
    }
    
}
