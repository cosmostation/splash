//
//  SettingSwitch.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/07.
//

import UIKit

class SettingSwitch: UITableViewCell {
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var setSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var actionToggle: ((Bool) -> Void)? = nil
    
    @IBAction func onClickSwitch(_ sender: UISwitch) {
        self.actionToggle?(sender.isOn)
    }
}
