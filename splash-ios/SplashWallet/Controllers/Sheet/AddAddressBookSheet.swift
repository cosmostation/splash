//
//  AddAddressBookSheet.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/13.
//

import UIKit
import MaterialComponents

class AddAddressBookSheet: BaseVC, ScanDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var addressBookTitle: UILabel!
    @IBOutlet weak var nameTextField: MDCOutlinedTextField!
    @IBOutlet weak var addressTextField: MDCOutlinedTextField!
    @IBOutlet weak var confirmBtn: BaseButton!
    
    var addressBookType: AddressBookType?
    var addressBookDelegate: AddAddressBookDelegate?
    var addressBook: AddressBook?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let trailingView = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        trailingView.btnAddressBook.isHidden = true
        trailingView.actionScan = { self.onClickScan() }
        
        addressTextField.setup()
        addressTextField.trailingView = trailingView
        addressTextField.trailingViewMode = .always
        addressTextField.setup()
        addressTextField.delegate = self
        
        onUpdateview()
    }
    
    override func setLocalizedString() {
        if (addressBookType == .Add) {
            addressBookTitle.text = NSLocalizedString("vc_title_add_address_book", comment: "")
        } else if (addressBookType == .Edit) {
            addressBookTitle.text = NSLocalizedString("vc_title_edit_address_book", comment: "")
        }
        nameTextField.label.text = NSLocalizedString("book_name", comment: "")
        addressTextField.label.text = NSLocalizedString("address", comment: "")
        confirmBtn.setTitle(NSLocalizedString("confirm", comment: ""), for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == addressTextField) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func onUpdateview() {
        if (addressBookType == .Edit && addressBook != nil) {
            nameTextField.text = addressBook?.name
            addressTextField.text = addressBook?.address
        }
    }
    
    func onClickScan() {
        let qrScanVC = QRScanVC(nibName: "QRScanVC", bundle: nil)
        qrScanVC.scanDelegate = self
        qrScanVC.modalPresentationStyle = .fullScreen
        present(qrScanVC, animated: true, completion: nil)
    }
    
    func onScanned(_ result: String) {
        addressTextField.text = result
    }
    
    @IBAction func onClickConfirm(_ sender: UIButton) {
        if onValidate() {
            var existed = BaseData.instance.getAddressBooks()
            let inputName = nameTextField.text?.trimmingCharacters(in: .whitespaces)
            let inputAddress = addressTextField.text?.trimmingCharacters(in: .whitespaces)
            let newBook = AddressBook.init(name: inputName, chainType: ChainSui().chainName, address: inputAddress)
            if (addressBookType == .Add) {
                existed.append(newBook)
                BaseData.instance.setAddressBooks(existed)
                
            } else if (addressBookType == .Edit) {
                if let index = existed.firstIndex(where: { $0.name == addressBook?.name && $0.address == addressBook?.address }) {
                    existed[index] = newBook
                }
                BaseData.instance.setAddressBooks(existed)
            }
            addressBookDelegate?.onAddedAddress(addressBookType)
            dismiss(animated: true)
        }
    }
    
    func onValidate() -> Bool {
        let inputName = nameTextField.text?.trimmingCharacters(in: .whitespaces)
        if (inputName?.isEmpty == true) {
            onShowToast(NSLocalizedString("error_name", comment: ""))
            return false
        }
        let inputAddress = addressTextField.text?.trimmingCharacters(in: .whitespaces)
        if (inputAddress?.isValidSuiAdderss() != true) {
            self.onShowToast(NSLocalizedString("error_invalid_address", comment: ""))
            return false
        }
        return true
    }
}

protocol AddAddressBookDelegate {
    func onAddedAddress(_ addressBookType : AddressBookType?)
}

public enum AddressBookType: Int {
    case Add = 0
    case Edit = 1
}
