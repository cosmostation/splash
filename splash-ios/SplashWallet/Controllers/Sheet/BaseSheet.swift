//
//  BaseSheet.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/03.
//

import UIKit
import SwiftyJSON

class BaseSheet: BaseVC {
    
    @IBOutlet weak var sheetTitle: UILabel!
    @IBOutlet weak var sheetTableView: UITableView!
    @IBOutlet weak var titleLine: UIView!
    
    var sheetType: SheetType?
    var sheetResult: BaseSheetDelegate?
    var otherAccounts: [BaseAccount]?
    var books: [AddressBook]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount?.chainConfig
        updateTitle()
        
        sheetTableView.delegate = self
        sheetTableView.dataSource = self
        sheetTableView.separatorStyle = .none
        sheetTableView.register(UINib(nibName: "ThemeCell", bundle: nil), forCellReuseIdentifier: "ThemeCell")
        sheetTableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        sheetTableView.register(UINib(nibName: "SelectChainCell", bundle: nil), forCellReuseIdentifier: "SelectChainCell")
        sheetTableView.register(UINib(nibName: "SelectCoinCell", bundle: nil), forCellReuseIdentifier: "SelectCoinCell")
        sheetTableView.register(UINib(nibName: "NewAccountCell", bundle: nil), forCellReuseIdentifier: "NewAccountCell")
        sheetTableView.register(UINib(nibName: "SelectBookCell", bundle: nil), forCellReuseIdentifier: "SelectBookCell")
        sheetTableView.register(UINib(nibName: "SelectValidatorCell", bundle: nil), forCellReuseIdentifier: "SelectValidatorCell")
        sheetTableView.sectionHeaderTopPadding = 0
    }
    
    func updateTitle() {
        if (sheetType == .SelectTheme) {
            sheetTitle.text = NSLocalizedString("select_theme", comment: "")
            
        } else if (sheetType == .SelectLanguage) {
            sheetTitle.text = NSLocalizedString("select_language", comment: "")
            
        } else if (sheetType == .SelectChain) {
            sheetTitle.text = NSLocalizedString("select_network", comment: "")
            
        } else if (sheetType == .SelectCoin) {
            sheetTitle.text = NSLocalizedString("select_asset", comment: "")
            
        } else if (sheetType == .SelectNewAccount) {
            sheetTitle.text = NSLocalizedString("create_account", comment: "")
            
        } else if (sheetType == .SelectBook) {
            titleLine.isHidden = true
            sheetTitle.text = NSLocalizedString("select_book", comment: "")
            otherAccounts = BaseData.instance.selectAccounts().filter { $0.id != cAccount.id }
            books = BaseData.instance.getAddressBooks()
            
        } else if (sheetType == .SelectValidator) {
            sheetTitle.text = NSLocalizedString("select_validator", comment: "")
            
        }
    }

}

extension BaseSheet: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (sheetType == .SelectBook) {
            if BaseData.instance.selectAddresses().count > 1 {
                return 2
            } else {
                return 1
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (sheetType == .SelectBook) {
            if (section == 0) {
                if otherAccounts!.count <= 0 { return 0 }
            } else if (section == 1) {
                if books!.count <= 0 { return 0 }
            }
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = BaseHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        if (sheetType == .SelectBook) {
            if (section == 0) {
                view.titleLabel.text = NSLocalizedString("my_account", comment: "")
            } else if (section == 1) {
                view.titleLabel.text = NSLocalizedString("address_book", comment: "")
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (sheetType == .SelectTheme) {
            return Theme.getThemes().count
            
        } else if (sheetType == .SelectLanguage) {
            return Language.getLanguages().count
            
        } else if (sheetType == .SelectChain) {
            return getSupportChainConfigs().count
            
        } else if (sheetType == .SelectCoin) {
            return DataManager.shared.suiBalances.count
            
        } else if (sheetType == .SelectNewAccount) {
            return 3
            
        } else if (sheetType == .SelectBook) {
            if (section == 0) {
                return otherAccounts!.count
            } else {
                return books!.count
            }
            
        }  else if (sheetType == .SelectValidator) {
            return DataManager.shared.suiActiveValidators.count
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (sheetType == .SelectTheme) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"ThemeCell") as? ThemeCell
            cell?.onBindView(indexPath.row)
            return cell!
            
        } else if (sheetType == .SelectLanguage) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"LanguageCell") as? LanguageCell
            cell?.onBindView(indexPath.row)
            return cell!
            
        } else if (sheetType == .SelectChain) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"SelectChainCell") as? SelectChainCell
            cell?.onBindChain(cChainConfig, getSupportChainConfigs()[indexPath.row])
            return cell!
            
        } else if (sheetType == .SelectCoin) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"SelectCoinCell") as? SelectCoinCell
            cell?.onBindCoin(cChainConfig, DataManager.shared.suiBalances[indexPath.row])
            return cell!
            
        } else if (sheetType == .SelectNewAccount) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"NewAccountCell") as? NewAccountCell
            cell?.onBindView(indexPath.row)
            return cell!
            
        } else if (sheetType == .SelectBook) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"SelectBookCell") as? SelectBookCell
            if (indexPath.section == 0) {
                cell?.onBindAccount(cChainConfig, otherAccounts![indexPath.row])
            } else {
                cell?.onBindBook(books![indexPath.row])
            }
            return cell!
            
        } else if (sheetType == .SelectValidator) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"SelectValidatorCell") as? SelectValidatorCell
            cell?.onBindValidator(indexPath)
            return cell!
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (sheetType == .SelectBook) {
            var address: String?
            if (indexPath.section == 0) {
                let otherAccount = otherAccounts![indexPath.row]
                address = BaseData.instance.selectAddress(otherAccount.id!, cChainConfig.chainName)?.address
            } else {
                address = books![indexPath.row].address
            }
            sheetResult?.onSelectSheet(sheetType, BaseSheetResult.init(indexPath.row, address))
            
        } else if (sheetType == .SelectChain) {
            if (indexPath.row == 0) {
                return
            } else {
                sheetResult?.onSelectSheet(sheetType, BaseSheetResult.init(indexPath.row, nil))
            }
            
        } else {
            sheetResult?.onSelectSheet(sheetType, BaseSheetResult.init(indexPath.row, nil))
        }
        dismiss(animated: true)
    }
}

protocol BaseSheetDelegate {
    func onSelectSheet(_ sheetType: SheetType?, _ result: BaseSheetResult)
}

public struct BaseSheetResult {
    var position: Int?
    var address: String?
    
    init(_ position: Int? = nil, _ address: String? = nil) {
        self.position = position
        self.address = address
    }
}

public enum SheetType: Int {
    case SelectTheme = 0
    case SelectLanguage = 1
    case SelectChain = 2
    case SelectCoin = 3
    case SelectNewAccount = 4
    case SelectBook = 5
    case SelectValidator = 6
}
