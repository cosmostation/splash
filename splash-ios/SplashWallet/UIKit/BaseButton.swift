//
//  BaseButton.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/15.
//

import UIKit

class BaseButton: UIButton {
    
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
            self.backgroundColor = .primary
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

extension UIButton {
    func alignTextBelow(spacing: CGFloat = 8.0) {
        guard let image = self.imageView?.image else {
            return
        }
        
        guard let titleLabel = self.titleLabel else {
            return
        }
        
        guard let titleText = titleLabel.text else {
            return
        }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])
        
        titleEdgeInsets = UIEdgeInsets(top: 12, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing) + 4, left: 0, bottom: 0, right: -titleSize.width)
    }
}
