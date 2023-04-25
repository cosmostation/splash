//
//  TxCheckSendCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/11.
//

import UIKit

class TxCheckSendCell: UITableViewCell {
    
    @IBOutlet weak var recipientAddressTitle: UILabel!
    @IBOutlet weak var sendAmountTitle: UILabel!
    @IBOutlet weak var txFeeTitle: UILabel!
    
    @IBOutlet weak var recipientAddressLabel: UILabel!
    @IBOutlet weak var sendAmountLabel: UILabel!
    @IBOutlet weak var txFeeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        recipientAddressTitle.text = NSLocalizedString("recipient_address", comment: "")
        sendAmountTitle.text = NSLocalizedString("to_send_amount", comment: "")
        txFeeTitle.text = NSLocalizedString("tx_fee", comment: "")
    }
    
    func onBindView(_ summary: [String : String]?) {
        if let summary = summary {
            recipientAddressLabel.text = summary["recipient"]
            sendAmountLabel.text = summary["sendAmount"]
            txFeeLabel.text = summary["feeAmount"]
        }
    }
    
}
