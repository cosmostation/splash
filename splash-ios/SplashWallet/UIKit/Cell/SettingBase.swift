//
//  SettingBase.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/07.
//

import UIKit

class SettingBase: UITableViewCell {
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.msgLabel.text = ""
    }
}
