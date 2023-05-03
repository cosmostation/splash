//
//  MainTabSetting.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/01/07.
//

import UIKit

class MainTabSetting: BaseVC, BaseSheetDelegate, SelectAccountDelegate {
    
    @IBOutlet weak var settingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.separatorStyle = .none
        settingTable.register(UINib(nibName: "SettingBase", bundle: nil), forCellReuseIdentifier: "SettingBase")
        settingTable.register(UINib(nibName: "SettingSwitch", bundle: nil), forCellReuseIdentifier: "SettingSwitch")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDataFetched), name: Notification.Name("DataFetched"), object: nil)
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        onUpdateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DataFetched"), object: nil)
    }
    
    func onUpdateView() {
        settingTable.reloadData()
    }
    
    @objc func onDataFetched() {
        onUpdateView()
    }
    
    
    func onSelectSheet(_ sheetType: SheetType?, _ result: BaseSheetResult) {
        if (sheetType == .SelectTheme) {
            if (BaseData.instance.getTheme() != result.position) {
                BaseData.instance.setTheme(result.position!)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.onStartMainTab(false)
                });
            }
            
        } else if (sheetType == .SelectLanguage) {
            if (BaseData.instance.getLanguage() != result.position) {
                BaseData.instance.setLanguage(result.position!)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.onStartMainTab(false)
                });
            }
            
        } else if (sheetType == .SelectChain) {
            let selectedChain = getSupportChainConfigs()[result.position!]
            if (selectedChain.chainName != cChainConfig.chainName) {
                BaseData.instance.setRecentChain(selectedChain)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.onStartMainTab(false)
                });
            }
        }
        
    }
    
    func onClickAccountDetail() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            let accountListVC = AccountListVC(nibName: "AccountListVC", bundle: nil)
            accountListVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(accountListVC, animated: true)
        });
    }
    
    func onSelectAccount(_ account: BaseAccount) {
        if (account.id != self.cAccount.id) {
            BaseData.instance.setRecentAccount(account.id!)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.onStartMainTab(false)
            });
        }
    }

}
extension MainTabSetting: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SettingHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        if (section == 0) {
            view.titleLabel.text = NSLocalizedString("set_section_wallet", comment: "")
        } else if (section == 1) {
            view.titleLabel.text = NSLocalizedString("set_section_general", comment: "")
        } else if (section == 2) {
            view.titleLabel.text = NSLocalizedString("set_section_security", comment: "")
        } else if (section == 3) {
            view.titleLabel.text = NSLocalizedString("set_section_app_info", comment: "")
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) { return 4 }
        else if (section == 1) { return 3 }
        else if (section == 2) { return 3 }
        else if (section == 3) { return 4 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) { return 0 }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 1) { return 0 }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 2) { return 0 }
        } else if (indexPath.section == 3) {
            if (indexPath.row == 3) { return 0 }
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let baseCell = tableView.dequeueReusableCell(withIdentifier:"SettingBase") as? SettingBase
        let switchCell = tableView.dequeueReusableCell(withIdentifier:"SettingSwitch") as? SettingSwitch
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                baseCell?.iconImg.image = UIImage(named: "set_account")
                baseCell?.titleLabel.text = NSLocalizedString("set_section_wallet", comment: "")
                baseCell?.msgLabel.text = cAccount.name
                return baseCell!
                
            } else if (indexPath.row == 1) {
                baseCell?.iconImg.image = UIImage(named: "set_network")
                baseCell?.titleLabel.text = NSLocalizedString("set_network", comment: "")
                baseCell?.msgLabel.text = cChainConfig.chainDpName
                return baseCell!
                
            } else if (indexPath.row == 2) {
                baseCell?.iconImg.image = UIImage(named: "set_dapps")
                baseCell?.titleLabel.text = NSLocalizedString("set_dapps", comment: "")
                baseCell?.msgLabel.text = "0"
                return baseCell!
                
            } else if (indexPath.row == 3) {
                baseCell?.iconImg.image = UIImage(named: "set_addressbook")
                baseCell?.titleLabel.text = NSLocalizedString("set_address_book", comment: "")
                baseCell?.msgLabel.text = String(BaseData.instance.getAddressBooks().count)
                return baseCell!
            }
            
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                baseCell?.iconImg.image = UIImage(named: "set_theme")
                baseCell?.titleLabel.text = NSLocalizedString("set_theme", comment: "")
                baseCell?.msgLabel.text = Theme.getThemes()[BaseData.instance.getTheme()].description
                return baseCell!
                
            } else if (indexPath.row == 1) {
                baseCell?.iconImg.image = UIImage(named: "set_currency")
                baseCell?.titleLabel.text = NSLocalizedString("set_currency", comment: "")
                baseCell?.msgLabel.text = "USD"
                return baseCell!
                
            } else if (indexPath.row == 2) {
                baseCell?.iconImg.image = UIImage(named: "set_language")
                baseCell?.titleLabel.text = NSLocalizedString("set_language", comment: "")
                baseCell?.msgLabel.text = Language.getLanguages()[BaseData.instance.getLanguage()].description
                return baseCell!
            }
            
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                switchCell?.iconImg.image = UIImage(named: "set_app_lock")
                switchCell?.titleLabel.text = NSLocalizedString("set_app_lock", comment: "")
                switchCell?.setSwitch.isOn = BaseData.instance.getAppLock()
                switchCell?.actionToggle = { toggle in
                    BaseData.instance.setAppLock(toggle)
                }
                return switchCell!
                
            } else if (indexPath.row == 1) {
                switchCell?.iconImg.image = UIImage(named: "set_bio")
                switchCell?.titleLabel.text = NSLocalizedString("set_bio", comment: "")
                switchCell?.setSwitch.isOn = BaseData.instance.getBioAuth()
                switchCell?.actionToggle = { toggle in
                    BaseData.instance.setBioAuth(toggle)
                }
                return switchCell!
                
            } else if (indexPath.row == 2) {
                switchCell?.iconImg.image = UIImage(named: "set_hide_asset")
                switchCell?.titleLabel.text = NSLocalizedString("set_hide_asset", comment: "")
                return switchCell!
                
            }
            
        } else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                baseCell?.iconImg.image = UIImage(named: "set_github")
                baseCell?.titleLabel.text = NSLocalizedString("set_gitHub", comment: "")
                baseCell?.msgLabel.text = ""
                return baseCell!
                
            } else if (indexPath.row == 1) {
                baseCell?.iconImg.image = UIImage(named: "set_version")
                baseCell?.titleLabel.text = NSLocalizedString("set_version", comment: "")
                baseCell?.msgLabel.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
                return baseCell!
                
            } else if (indexPath.row == 2) {
                baseCell?.iconImg.image = UIImage(named: "set_twitter")
                baseCell?.titleLabel.text = NSLocalizedString("set_twitter", comment: "")
                baseCell?.msgLabel.text = ""
                return baseCell!
                
            } else if (indexPath.row == 3) {
                baseCell?.iconImg.image = UIImage(named: "set_feedback")
                baseCell?.titleLabel.text = NSLocalizedString("set_feedback", comment: "")
                baseCell?.msgLabel.text = ""
                return baseCell!
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                let accountListVC = AccountListVC(nibName: "AccountListVC", bundle: nil)
                accountListVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(accountListVC, animated: true)
                
            } else if (indexPath.row == 1) {
                let baseSheet = BaseSheet(nibName: "BaseSheet", bundle: nil)
                baseSheet.sheetResult = self
                baseSheet.sheetType = .SelectChain
                onStartSheet(baseSheet)
                
            } else if (indexPath.row == 2) {
                print("click walletconnect")
                
            } else if (indexPath.row == 3) {
                let bookListVC = AddressBookListVC(nibName: "AddressBookListVC", bundle: nil)
                bookListVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(bookListVC, animated: true)
                
            }
            
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                let baseSheet = BaseSheet(nibName: "BaseSheet", bundle: nil)
                baseSheet.sheetResult = self
                baseSheet.sheetType = .SelectTheme
                onStartSheet(baseSheet)
                
            } else if (indexPath.row == 1) {
                print("click currency")
                
            } else if (indexPath.row == 2) {
                let baseSheet = BaseSheet(nibName: "BaseSheet", bundle: nil)
                baseSheet.sheetResult = self
                baseSheet.sheetType = .SelectLanguage
                onStartSheet(baseSheet)
            }
            
        } else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                guard let url = URL(string: "https://github.com/cosmostation/splash") else { return }
                self.onStartSafariWeb(url)
                
            } else if (indexPath.row == 1) {
                let urlAppStore = URL(string: "itms-apps://itunes.apple.com/app/6447570048")
                if(UIApplication.shared.canOpenURL(urlAppStore!)) {
                    UIApplication.shared.open(urlAppStore!, options: [:], completionHandler: nil)
                }
                
            } else if (indexPath.row == 2) {
                let appURL = NSURL(string: "twitter://user?screen_name=splash_sui")!
                let application = UIApplication.shared
                   if application.canOpenURL(appURL as URL) {
                        application.open(appURL as URL)
                   } else {
                       guard let url = URL(string: "https://twitter.com/splash_sui") else { return }
                       self.onStartSafariWeb(url)
                   }
                
            } else if (indexPath.row == 3) {
                print("click feedback")
            }
        }
    }
    
}
