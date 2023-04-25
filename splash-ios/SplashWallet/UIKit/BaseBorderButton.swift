//
//  BaseBorderButton.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/15.
//

import UIKit

class BaseBorderButton: UIButton {
    
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
        if (self.isEnabled) {
            self.layer.borderColor = UIColor.primary.cgColor
            self.tintColor = .base01
            self.setTitleColor(.primary, for: .normal)
        } else {
            self.layer.borderColor = UIColor.base03.cgColor
            self.setTitleColor(.base04, for: .normal)
        }
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
