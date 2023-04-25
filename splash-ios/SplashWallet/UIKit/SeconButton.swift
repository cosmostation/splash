//
//  SeconButton.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/11.
//

import UIKit

class SeconButton: UIButton {
    
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
        if (self.isEnabled) {
            self.backgroundColor = .secondary
            self.tintColor = .base01
            self.setTitleColor(.white, for: .normal)
        } else {
            self.backgroundColor = .base03
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
