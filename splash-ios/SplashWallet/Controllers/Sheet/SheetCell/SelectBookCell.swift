//
//  SelectBookCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/13.
//

import UIKit

class SelectBookCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func onBindAccount(_ currentChain: ChainConfig?, _ account: BaseAccount) {
        nameLabel.text = account.name
        Task {
            if let baseAccount = await account.getBaseAddress(currentChain!) {
                addressLabel.text = baseAccount.address
            }
        }
    }
    
    func onBindBook(_ book: AddressBook) {
        nameLabel.text = book.name
        addressLabel.text = book.address
    }
}
