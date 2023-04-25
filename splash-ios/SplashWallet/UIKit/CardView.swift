//
//  CardView.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/19.
//

import UIKit

class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.backgroundColor = .base02
        self.layer.borderColor = UIColor.base03.cgColor
        self.layer.masksToBounds = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setup()
    }
    
}
