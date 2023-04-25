//
//  ThemeCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/03.
//

import UIKit

class ThemeCell: UITableViewCell {
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkedImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func onBindView(_ position: Int) {
        let theme = Theme.getThemes()[position]
        titleLabel.text = theme.description
        
        let cTheme = Theme.getThemes()[BaseData.instance.getTheme()]
        if (theme.description == cTheme.description) {
            rootView.backgroundColor = .base02
            checkedImg.isHidden = false
        } else {
            rootView.backgroundColor = .base01
            checkedImg.isHidden = true
        }
    }
    
}
