//
//  MyStakesCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/21.
//

import UIKit
import SwiftyJSON

class MyStakesCell: UITableViewCell {
    
    @IBOutlet weak var objectIdTitle: UILabel!
    @IBOutlet weak var pendingImg: UIImageView!
    @IBOutlet weak var stakedTitle: UILabel!
    @IBOutlet weak var earnedTitle: UILabel!
    @IBOutlet weak var startEpochTitle: UILabel!
    @IBOutlet weak var stakedLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var startEpochLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        objectIdTitle.text = NSLocalizedString("my_staking_status", comment: "")
        stakedTitle.text = NSLocalizedString("staked_amount", comment: "")
        earnedTitle.text = NSLocalizedString("earned_amount", comment: "")
        startEpochTitle.text = NSLocalizedString("start_earn_epoch", comment: "")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pendingImg.isHidden = true
    }
    
    func onBindView(_ object: JSON) {
        objectIdTitle.text = object["stakedSuiId"].stringValue
        if (object["status"].stringValue == "Pending") {
            pendingImg.isHidden = false
        }
        
        stakedLabel.text = DecimalUtils.toString(object["principal"].stringValue, 9, 9)
        earnedLabel.text = DecimalUtils.toString(object["estimatedReward"].stringValue, 9, 9)
        startEpochLabel.text = "Epoch #" + object["stakeActiveEpoch"].stringValue
    }
    
}
