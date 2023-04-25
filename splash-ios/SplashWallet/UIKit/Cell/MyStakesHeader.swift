//
//  MyStakesHeader.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/21.
//

import UIKit

class MyStakesHeader: UIView {
    
    private let xibName = "MyStakesHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBOutlet weak var valImgView: UIImageView!
    @IBOutlet weak var valNameLabel: UILabel!
    @IBOutlet weak var valStakedLabel: UILabel!
    @IBOutlet weak var toggleBtn: UIButton!
    
}
