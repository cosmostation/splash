//
//  TxCheckSheet.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/11.
//

import UIKit

class TxCheckSheet: BaseVC {
    
    @IBOutlet weak var sheetTitle: UILabel!
    @IBOutlet weak var sheetTableView: UITableView!
    
    @IBOutlet weak var sheetCancelBtn: SeconButton!
    @IBOutlet weak var sheetConfirmBtn: BaseButton!
    
    var txCheckType: TxCheckSheetType?
    var txCheckDelegate: TxCheckSheetDelegate?
    var txSummary: [String : String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount?.chainConfig
        
        sheetTableView.delegate = self
        sheetTableView.dataSource = self
        sheetTableView.separatorStyle = .none
        sheetTableView.register(UINib(nibName: "TxCheckSendCell", bundle: nil), forCellReuseIdentifier: "TxCheckSendCell")
        sheetTableView.register(UINib(nibName: "TxCheckNftSendCell", bundle: nil), forCellReuseIdentifier: "TxCheckNftSendCell")
        sheetTableView.register(UINib(nibName: "TxCheckStakeCell", bundle: nil), forCellReuseIdentifier: "TxCheckStakeCell")
        sheetTableView.register(UINib(nibName: "TxCheckUnstakeCell", bundle: nil), forCellReuseIdentifier: "TxCheckUnstakeCell")
        sheetTableView.sectionHeaderTopPadding = 0
        
        if (txCheckType == .TxSend) {
            sheetTitle.text = NSLocalizedString("vc_title_send_coin", comment: "")
        } else if (txCheckType == .TxNFTSend) {
            sheetTitle.text = NSLocalizedString("vc_title_send_nft", comment: "")
        } else if (txCheckType == .TxStake) {
            sheetTitle.text = NSLocalizedString("vc_title_check_stake", comment: "")
        } else if (txCheckType == .TxUnstake) {
            sheetTitle.text = NSLocalizedString("vc_title_check_unstake", comment: "")
        }
    }
    
    
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        txCheckDelegate?.onTxConfirmed(txCheckType, false)
        dismiss(animated: true)
    }
    
    @IBAction func onClickConfirm(_ sender: UIButton) {
        txCheckDelegate?.onTxConfirmed(txCheckType, true)
        dismiss(animated: true)
    }

}


extension TxCheckSheet: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (txCheckType == .TxSend) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"TxCheckSendCell") as? TxCheckSendCell
            cell?.onBindView(txSummary)
            return cell!
            
        } else if (txCheckType == .TxNFTSend) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"TxCheckNftSendCell") as? TxCheckNftSendCell
            cell?.onBindView(txSummary)
            return cell!
            
        } else if (txCheckType == .TxStake) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"TxCheckStakeCell") as? TxCheckStakeCell
            cell?.onBindView(txSummary)
            return cell!
            
        } else if (txCheckType == .TxUnstake) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"TxCheckUnstakeCell") as? TxCheckUnstakeCell
            cell?.onBindView(txSummary)
            return cell!
        }
        return UITableViewCell()
    }
    
}

protocol TxCheckSheetDelegate {
    func onTxConfirmed(_ sheetType: TxCheckSheetType?, _ result: Bool)
}

public enum TxCheckSheetType: Int {
    case TxSend = 0
    case TxNFTSend = 1
    case TxStake = 2
    case TxUnstake = 3
}
