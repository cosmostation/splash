//
//  SelectAccountSheet.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/02/27.
//

import UIKit

class SelectAccountSheet: BaseVC {
    
    @IBOutlet weak var accountsTableView: UITableView!
    
    var accounts = Array<BaseAccount>()
    var resultDelegate: SelectAccountDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        accounts = BaseData.instance.selectAccounts()
        
        accountsTableView.delegate = self
        accountsTableView.dataSource = self
        accountsTableView.separatorStyle = .none
        accountsTableView.register(UINib(nibName: "SelectAccountCell", bundle: nil), forCellReuseIdentifier: "SelectAccountCell")
        accountsTableView.sectionHeaderTopPadding = 0
    }

    @IBAction func onClickDetail(_ sender: UIButton) {
        resultDelegate?.onClickAccountDetail()
        dismiss(animated: true)
    }
}


extension SelectAccountSheet: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"SelectAccountCell") as? SelectAccountCell
        cell?.onBindAccount(cAccount, cAccount.chainConfig, accounts[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultDelegate?.onSelectAccount(accounts[indexPath.row])
        dismiss(animated: true)
    }
}

protocol SelectAccountDelegate {
    func onClickAccountDetail()
    func onSelectAccount(_ account: BaseAccount)
}
