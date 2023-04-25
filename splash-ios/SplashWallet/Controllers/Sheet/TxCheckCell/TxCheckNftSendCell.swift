//
//  TxCheckNftSendCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/11.
//

import UIKit

class TxCheckNftSendCell: UITableViewCell {
    
    @IBOutlet weak var recipientAddressTitle: UILabel!
    @IBOutlet weak var sendNftTitle: UILabel!
    @IBOutlet weak var txFeeTitle: UILabel!
    
    @IBOutlet weak var recipientAddressLabel: UILabel!
    @IBOutlet weak var sendNftImg: UIImageView!
    @IBOutlet weak var sendNftLabel: UILabel!
    @IBOutlet weak var txFeeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        recipientAddressTitle.text = NSLocalizedString("recipient_address", comment: "")
        txFeeTitle.text = NSLocalizedString("tx_fee", comment: "")
    }
    
    func onBindView(_ summary: [String : String]?) {
        if let summary = summary {
            recipientAddressLabel.text = summary["recipient"]
            sendNftLabel.text = summary["nftName"]
            txFeeLabel.text = summary["feeAmount"]
            
            if let url = URL(string: summary["nftUrl"] ?? "") {
                sendNftImg.af.setImage(withURL: url)
            } else {
                sendNftImg.image = UIImage(named: "nft_default")
            }
        }
    }
    
}
