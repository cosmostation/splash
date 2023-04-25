//
//  DeleteAddressBookSheet.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/13.
//

import UIKit

class DeleteAddressBookSheet: BaseVC {

    @IBOutlet weak var deleteBookTitle: UILabel!
    @IBOutlet weak var deleteNameLabel: UILabel!
    @IBOutlet weak var deleteAddressLabel: UILabel!
    @IBOutlet weak var btnConfirm: RedButton!
    
    var deleteBookDelegate: DeleteAddressBookDelegate?
    var addressBook: AddressBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteNameLabel.text = addressBook?.name
        deleteAddressLabel.text = addressBook?.address
    }
    
    override func setLocalizedString() {
        deleteBookTitle.text = NSLocalizedString("vc_title_delete_address_book", comment: "")
        btnConfirm.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)
    }

    @IBAction func onClickDelete(_ sender: UIButton) {
        var existed = BaseData.instance.getAddressBooks()
        if let index = existed.firstIndex(where: { $0.name == addressBook?.name && $0.address == addressBook?.address }) {
            existed.remove(at: index)
            BaseData.instance.setAddressBooks(existed)
        }
        deleteBookDelegate?.onDeletedAddress()
        dismiss(animated: true)
    }
}

protocol DeleteAddressBookDelegate {
    func onDeletedAddress()
}
