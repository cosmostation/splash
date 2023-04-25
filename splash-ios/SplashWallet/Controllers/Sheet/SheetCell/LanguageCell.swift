//
//  LanguageCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/03.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func onBindView(_ position: Int) {
        let language = Language.getLanguages()[position]
        titleLabel.text = language.description
        
        let cLanguage = Language.getLanguages()[BaseData.instance.getLanguage()]
        if (language.description == cLanguage.description) {
            rootView.backgroundColor = .base02
            checkedImg.isHidden = false
        } else {
            rootView.backgroundColor = .base01
            checkedImg.isHidden = true
        }
    }
}
