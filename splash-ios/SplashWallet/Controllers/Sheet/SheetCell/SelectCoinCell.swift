//
//  SelectCoinCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/13.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class SelectCoinCell: UITableViewCell {
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var coinImgView: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func onBindCoin(_ chainConfig: ChainConfig?, _ balance: (String, NSDecimalNumber)) {
        symbolLabel.text = balance.0.getCoinSymbol()
        amountLabel.text = DecimalUtils.toString(balance.1.stringValue, 9)
        if (balance.0.contains(SUI_DENOM) == true) {
            coinImgView.image = UIImage(named: "coin_sui")
        } else {
            coinImgView.image = UIImage(named: "coin_default")
        }
    }
    
}