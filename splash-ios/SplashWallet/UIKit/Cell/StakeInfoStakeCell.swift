//
//  StakeInfoStakeCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/18.
//

import UIKit
import SwiftyJSON

class StakeInfoStakeCell: UITableViewCell {

    @IBOutlet weak var stakenowTitle: UILabel!
    @IBOutlet weak var stakenowMsg: UILabel!
    @IBOutlet weak var description0Title: UILabel!
    @IBOutlet weak var description1Title: UILabel!
    @IBOutlet weak var description2Title: UILabel!
    @IBOutlet weak var description3Title: UILabel!
    @IBOutlet weak var availableTitle: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var btnStakenow: BaseButton!
    
    var actionStake: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        let epoch = DataManager.shared.suiSystem!["epoch"].int64Value
        
        stakenowTitle.text = NSLocalizedString("start_stake_title", comment: "")
        stakenowMsg.text = NSLocalizedString("start_stake_msg", comment: "")
        description0Title.text = NSLocalizedString("start_stake_des0", comment: "")
        description1Title.text = String(format: NSLocalizedString("start_stake_des1", comment: ""), "#"+String(epoch))
        description2Title.text = String(format: NSLocalizedString("start_stake_des2", comment: ""), "#"+String(epoch + 1))
        description3Title.text = NSLocalizedString("start_stake_des3", comment: "")
        availableTitle.text = NSLocalizedString("available", comment: "")
        btnStakenow.setTitle(NSLocalizedString("stake_now", comment: ""), for: .normal)
        btnStakenow.titleLabel?.font = font6
    }
    
    func onBindView() {
        if let balance = DataManager.shared.suiBalances.filter({ $0.0.contains(SUI_DENOM) == true }).first {
            availableLabel.text = DecimalUtils.toString(balance.1.stringValue, 9, 9)
        }
    }
    
    @IBAction func onClickStake(_ sender: UIButton) {
        self.actionStake?()
    }
}
