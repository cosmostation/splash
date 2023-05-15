//
//  ActivityCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/02/22.
//

import UIKit
import SwiftyJSON

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func onBindActivity(_ myAddress: String?, _ activity: JSON) {
        if (activity["effects"]["status"]["status"].stringValue == "success") {
            statusIconImageView.image = UIImage(named: "icon_tx_success")
        } else {
            statusIconImageView.image = UIImage(named: "icon_tx_fail")
        }

//        print("activity ", activity)
        var title = ""
        var description = ""
        let txs = activity["transaction"]["data"]["transaction"]["transactions"].arrayValue
        if (!txs[0].isEmpty) {
            description = txs.last?.dictionaryValue.keys.first ?? "Unknown"
            if (txs.count > 1) {
                description = description +  " + " + String(txs.count)
            }
            
            let sender = activity["transaction"]["data"]["sender"].stringValue
            if (sender == myAddress) {
                title = "Sent"
            } else {
                title = "Received"
            }
            
            txs.forEach { tx in
                if (tx["MoveCall"]["function"].stringValue == "request_withdraw_stake") {
                    title = "Unstake"
                }
            }
            txs.forEach { tx in
                if (tx["MoveCall"]["function"].stringValue == "request_add_stake") {
                    title = "Stake"
                }
            }
        }
        
        
        var action = ""
        let balanceChanges = activity["balanceChanges"].arrayValue
        balanceChanges.forEach { balanceChange in
            if (balanceChange["owner"]["AddressOwner"].stringValue == myAddress) {
                var symbol = balanceChange["coinType"].stringValue.components(separatedBy: "::").last ?? ""
                let amount = balanceChange["amount"].int64Value
                action = DecimalUtils.toString(amount, 9)! + " " + symbol.trunc(length: 7)
                if let meta = DataManager.shared.suiCoinMeta.first(where: { item in item.key.contains(balanceChange["coinType"].stringValue) })?.value {
                    let decimal = meta["decimals"].int16Value
                    symbol = meta["symbol"].stringValue
                    action = DecimalUtils.toString(amount, decimal)! + " " + symbol.trunc(length: 7)
                }
                
            }
        }
        
        
        titleLabel.text = title
        titleLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.text = description
        descriptionLabel.adjustsFontSizeToFitWidth = true
        actionLabel.text = action
        actionLabel.adjustsFontSizeToFitWidth = true
        
        

        let digest = activity["digest"].stringValue
        hashLabel.text = digest

        let time = activity["timestampMs"].intValue
        timeLabel.text = "(" + TimeUtils.toString(time) + ")"
        
        let checkpoint = activity["checkpoint"].stringValue
        blockLabel.text = checkpoint
        
    }
    
}
