//
//  TxCheckUnstakeCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/11.
//

import UIKit

class TxCheckUnstakeCell: UITableViewCell {
    
    @IBOutlet weak var validatorTitle: UILabel!
    @IBOutlet weak var unstakeAmountTitle: UILabel!
    @IBOutlet weak var txFeeTitle: UILabel!
    
    @IBOutlet weak var validatorLabel: UILabel!
    @IBOutlet weak var unstakeAmountLabel: UILabel!
    @IBOutlet weak var txFeeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        validatorTitle.text = NSLocalizedString("validator", comment: "")
        unstakeAmountTitle.text = NSLocalizedString("to_unstake_amount", comment: "")
        txFeeTitle.text = NSLocalizedString("tx_fee", comment: "")
    }
    
    func onBindView(_ summary: [String : String]?) {
        if let summary = summary {
            validatorLabel.text = summary["validator"]
            unstakeAmountLabel.text = summary["unstakeAmount"]
            txFeeLabel.text = summary["feeAmount"]
        }
    }
    
}
