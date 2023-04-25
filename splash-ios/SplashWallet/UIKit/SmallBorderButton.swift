//
//  SmallBorderButton.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/11.
//

import UIKit

class SmallBorderButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.titleLabel?.font = font4
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.base03.cgColor
        self.tintColor = .base01
        self.setTitleColor(.text01, for: .normal)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setup()
    }
    
    override var isEnabled: Bool {
        didSet {
            setup()
        }
    }
}
