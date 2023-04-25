//
//  InputAccessoryView.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/12.
//

import UIKit

class InputAccessoryView: UIView {
    private let xibName = "InputAccessoryView"
    
    @IBOutlet weak var btnAddressBook: UIButton!
    @IBOutlet weak var btnScan: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    var actionAddressBook: (() -> Void)? = nil
    @IBAction func onClickAddressBook(_ sender: UIButton) {
        self.actionAddressBook?()
    }
    
    var actionScan: (() -> Void)? = nil
    @IBAction func onClickScan(_ sender: UIButton) {
        self.actionScan?()
    }
}
