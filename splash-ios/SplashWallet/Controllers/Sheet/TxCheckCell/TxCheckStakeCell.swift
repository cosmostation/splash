//
//  TxCheckStakeCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/11.
//

import UIKit

class TxCheckStakeCell: UITableViewCell {
    
    @IBOutlet weak var validatorTitle: UILabel!
    @IBOutlet weak var stakeAmountTitle: UILabel!
    @IBOutlet weak var txFeeTitle: UILabel!
    
    @IBOutlet weak var validatorLabel: UILabel!
    @IBOutlet weak var stakeAmountLabel: UILabel!
    @IBOutlet weak var txFeeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        validatorTitle.text = NSLocalizedString("validator", comment: "")
        stakeAmountTitle.text = NSLocalizedString("to_stake_amount", comment: "")
        txFeeTitle.text = NSLocalizedString("tx_fee", comment: "")
    }
    
    func onBindView(_ summary: [String : String]?) {
        if let summary = summary {
            validatorLabel.text = summary["validator"]
            stakeAmountLabel.text = summary["stakeAmount"]
            txFeeLabel.text = summary["feeAmount"]
        }
    }
    
}
