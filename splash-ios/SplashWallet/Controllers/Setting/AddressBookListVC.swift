//
//  AddressBookListVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/13.
//

import UIKit

class AddressBookListVC: BaseVC, AddAddressBookDelegate, DeleteAddressBookDelegate {
    
    @IBOutlet weak var booksTableView: UITableView!
    @IBOutlet weak var bookAddBtn: BaseButton!
    @IBOutlet weak var emptyView: UIView!
    
    var addressBookList = Array<AddressBook>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        
        booksTableView.delegate = self
        booksTableView.dataSource = self
        booksTableView.separatorStyle = .none
        booksTableView.register(UINib(nibName: "AddressBookCell", bundle: nil), forCellReuseIdentifier: "AddressBookCell")
        
        onUpdateView()
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_address_book_list", comment: "")
        bookAddBtn.setTitle(NSLocalizedString("add_address_book", comment: ""), for: .normal)
    }
    
    func onUpdateView() {
        addressBookList = BaseData.instance.getAddressBooks()
        if (addressBookList.count > 0) {
            booksTableView.reloadData()
            emptyView.isHidden = true
        } else {
            emptyView.isHidden = false
        }
    }

    @IBAction func onClickAdd(_ sender: UIButton) {
        let addAddressBookSheet = AddAddressBookSheet(nibName: "AddAddressBookSheet", bundle: nil)
        addAddressBookSheet.addressBookDelegate = self
        addAddressBookSheet.addressBookType = .Add
        onStartSheet(addAddressBookSheet, 340)
    }
    
    
    func onAddedAddress(_ addressBookType: AddressBookType?) {
        onUpdateView()
    }
    
    func onDeletedAddress() {
        onUpdateView()
    }
}


extension AddressBookListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressBookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"AddressBookCell") as? AddressBookCell
        let addressBook = addressBookList[indexPath.row]
        cell?.onBindAddress(cChainConfig, addressBook)
        cell?.actionEdit = {
            let addAddressBookSheet = AddAddressBookSheet(nibName: "AddAddressBookSheet", bundle: nil)
            addAddressBookSheet.addressBookDelegate = self
            addAddressBookSheet.addressBook = addressBook
            addAddressBookSheet.addressBookType = .Edit
            self.onStartSheet(addAddressBookSheet, 340)
        }
        cell?.actionDelete = {
            let deleteAddressBookSheet = DeleteAddressBookSheet(nibName: "DeleteAddressBookSheet", bundle: nil)
            deleteAddressBookSheet.deleteBookDelegate = self
            deleteAddressBookSheet.addressBook = addressBook
            self.onStartSheet(deleteAddressBookSheet, 340)
        }
        return cell!
    }
    
}
