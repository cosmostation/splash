//
//  AssetCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/01/09.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class AssetCell: UITableViewCell {
    
    @IBOutlet weak var coinImgView: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.coinImgView.image = UIImage(named: "coin_default")
    }
    
    func onBindSuiBalance(_ chainConfig: ChainConfig?, _ position: Int) {
        if (position == 0) {
            symbolLabel.text = "SUI"
            amountLabel.text = DecimalUtils.toString(DataManager.shared.getSuiAmount().stringValue, 9)
            coinImgView.image = UIImage(named: "coin_sui")
        } else {
            symbolLabel.text = "Staked SUI"
            amountLabel.text = DecimalUtils.toString(DataManager.shared.getSuiStakedAmount().stringValue, 9)
            coinImgView.image = UIImage(named: "coin_sui_staked")
        }
    }
    
    func onBindBalance(_ chainConfig: ChainConfig?, _ balance: (String, NSDecimalNumber)) {
        symbolLabel.text = balance.0.getCoinSymbol()
        amountLabel.text = DecimalUtils.toString(balance.1.stringValue, 9)
        coinImgView.image = UIImage(named: "coin_default")
    }
    
}
