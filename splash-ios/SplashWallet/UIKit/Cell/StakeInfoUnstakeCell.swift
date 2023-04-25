//
//  StakeInfoUnstakeCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/18.
//

import UIKit
import SwiftyJSON

class StakeInfoUnstakeCell: UITableViewCell {

    @IBOutlet weak var myStakingTitle: UILabel!
    @IBOutlet weak var totalStakedTitle: UILabel!
    @IBOutlet weak var stakedTitle: UILabel!
    @IBOutlet weak var earnedTitle: UILabel!
    @IBOutlet weak var totalStakedLabel: UILabel!
    @IBOutlet weak var stakedLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var btnUnstake: BaseButton!
    
    var actionUnStake: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        myStakingTitle.text = NSLocalizedString("my_staking_status", comment: "")
        totalStakedTitle.text = NSLocalizedString("total_staked", comment: "")
        stakedTitle.text = NSLocalizedString("staked", comment: "")
        earnedTitle.text = NSLocalizedString("earned", comment: "")
        btnUnstake.setTitle(NSLocalizedString("unstake", comment: ""), for: .normal)
        btnUnstake.titleLabel?.font = font6
    }
    
    func onBindView(_ suiStakeds: [JSON]) {
        var staked = NSDecimalNumber.zero
        var earned = NSDecimalNumber.zero
        suiStakeds.forEach { suiStaked in
            suiStaked["stakes"].arrayValue.forEach { stakes in
                staked = staked.adding(NSDecimalNumber(value: stakes["principal"].int64Value))
                earned = earned.adding(NSDecimalNumber(value: stakes["estimatedReward"].int64Value))
            }
        }
        
        stakedLabel.text = DecimalUtils.toString(staked.stringValue, 9, 9)
        earnedLabel.text = DecimalUtils.toString(earned.stringValue, 9, 9)
        totalStakedLabel.text = DecimalUtils.toString(staked.adding(earned).stringValue, 9, 9)
    }
    
    @IBAction func onClickUnstake(_ sender: UIButton) {
        self.actionUnStake?()
    }
}
