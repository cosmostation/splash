//
//  AccountListVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/02.
//

import UIKit

class AccountListVC: BaseVC, PincodeDelegate, RenameDelegate, DeleteDelegate, BaseSheetDelegate {
    
    @IBOutlet weak var accountsTableView: UITableView!
    @IBOutlet weak var addAccountBtn: BaseButton!
    
    var accounts = Array<BaseAccount>()
    var toShowAccount: BaseAccount?
    var toDeleteAccount: BaseAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        accounts = BaseData.instance.selectAccounts()
        
        accountsTableView.delegate = self
        accountsTableView.dataSource = self
        accountsTableView.separatorStyle = .none
        accountsTableView.register(UINib(nibName: "AccountSwitchCell", bundle: nil), forCellReuseIdentifier: "AccountSwitchCell")
        
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_account", comment: "")
        addAccountBtn.setTitle(NSLocalizedString("add_account", comment: ""), for: .normal)
    }
    
    func onRenamed() {
        accountsTableView.reloadData()
    }
    
    func onRequestDeleted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            let pinVC = PincodeVC(nibName: "PincodeVC", bundle: nil)
            pinVC.request = .deleteAccount
            pinVC.resultDelegate = self
            self.navigationController!.view.layer.add(self.moveinAni(), forKey: kCATransition)
            self.navigationController?.pushViewController(pinVC, animated: false)
        });
    }
    
    func pincodeResponse(_ request: PincodeRequest, _ result: PincodeResult) {
        if (result == .success) {
            if (request == .checkMnemonic) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    let checkMnemonicVC = CheckMnemonicVC(nibName: "CheckMnemonicVC", bundle: nil)
                    checkMnemonicVC.toShowAccount = self.toShowAccount
                    self.navigationController?.pushViewController(checkMnemonicVC, animated: true)
                    self.toShowAccount = nil
                });

            } else if (request == .checkPrivateKey) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    let checkPrivateKeyVC = CheckPrivateKeyVC(nibName: "CheckPrivateKeyVC", bundle: nil)
                    checkPrivateKeyVC.toShowAccount = self.toShowAccount
                    self.navigationController?.pushViewController(checkPrivateKeyVC, animated: true)
                    self.toShowAccount = nil
                });
                
            } else if (request == .deleteAccount) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    BaseData.instance.deleteAccount(self.toDeleteAccount!)
                    let accounts = BaseData.instance.selectAccounts()
                    if (self.toDeleteAccount?.name != self.cAccount.name) {
                        self.accounts = BaseData.instance.selectAccounts()
                        self.accountsTableView.reloadData()
                        self.toDeleteAccount = nil
                        
                    } else {
                        if (accounts.count > 0) {
                            let account = accounts.sorted { $0.time! > $1.time! }.first
                            BaseData.instance.setRecentAccount(account!.id!)
                            self.onStartMainTab()
                        } else {
                            self.onStartIntro()
                        }
                    }
                });
            }
        }
    }
    
    
    @IBAction func onClickAddAccount(_ sender: UIButton) {
        let baseSheet = BaseSheet(nibName: "BaseSheet", bundle: nil)
        baseSheet.sheetResult = self
        baseSheet.sheetType = .SelectNewAccount
        onStartSheet(baseSheet)
    }
    
    func onSelectSheet(_ sheetType: SheetType?, _ result: BaseSheetResult) {
        if (sheetType == .SelectNewAccount) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                if (result.position == 0) {
                    self.onNextVc(.create)
                } else if (result.position == 1) {
                    self.onNextVc(.mnemonc)
                } else if (result.position == 2) {
                    self.onNextVc(.privateKey)
                }
            });
        }
    }
    
    func onNextVc(_ type: NewAccountType) {
        let createNameVC = CreateNameVC(nibName: "CreateNameVC", bundle: nil)
        createNameVC.newAccountType = type
        self.navigationController?.pushViewController(createNameVC, animated: true)
    }
}


extension AccountListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"AccountSwitchCell") as? AccountSwitchCell
        cell?.onBindAccount(cChainConfig, accounts[indexPath.row])
        cell?.actionRename = {
            let renameSheet = RenameSheet(nibName: "RenameSheet", bundle: nil)
            renameSheet.toUpdateAccount = self.accounts[indexPath.row]
            renameSheet.resultDelegate = self
            self.onStartSheet(renameSheet, 240)
        }
        cell?.actionDelete = {
            self.toDeleteAccount = self.accounts[indexPath.row]
            let deleteAccountSheet = DeleteAccountSheet(nibName: "DeleteAccountSheet", bundle: nil)
            deleteAccountSheet.toDeleteAccount = self.toDeleteAccount
            deleteAccountSheet.resultDelegate = self
            self.onStartSheet(deleteAccountSheet, 340)
        }
        cell?.actionMnemonic = {
            if (self.accounts[indexPath.row].withMenmonic == true) {
                self.toShowAccount = self.accounts[indexPath.row]
                let pinVC = PincodeVC(nibName: "PincodeVC", bundle: nil)
                pinVC.request = .checkMnemonic
                pinVC.resultDelegate = self
                self.navigationController!.view.layer.add(self.moveinAni(), forKey: kCATransition)
                self.navigationController?.pushViewController(pinVC, animated: false)
                
            } else {
                self.onShowToast(NSLocalizedString("error_only_private_key", comment: ""))
            }
        }
        cell?.actionPrivateKey = {
            self.toShowAccount = self.accounts[indexPath.row]
            let pinVC = PincodeVC(nibName: "PincodeVC", bundle: nil)
            pinVC.request = .checkPrivateKey
            pinVC.resultDelegate = self
            self.navigationController!.view.layer.add(self.moveinAni(), forKey: kCATransition)
            self.navigationController?.pushViewController(pinVC, animated: false)
        }
        return cell!
    }
    
}
