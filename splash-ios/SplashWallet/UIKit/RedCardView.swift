//
//  RedCardView.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/01/06.
//

import UIKit

class RedCardView: UIView {
    
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
        self.backgroundColor = .bg_red
        self.layer.masksToBounds = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setup()
    }
    
}
