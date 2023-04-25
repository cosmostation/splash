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
    
    func onBindBalance(_ chainConfig: ChainConfig?, _ balance: (String, NSDecimalNumber)) {
//        let decimal = balance.1["decimals"].int16 ?? 9
//        let available = balance.0["totalBalance"].stringValue
//        let symbol = balance.1["symbol"].string ?? balance.0["coinType"].stringValue.components(separatedBy: "::").last!
//
//        self.symbolLabel.text = symbol
//        self.amountLabel.text = DecimalUtils.toString(available, decimal)
//        if let url = URL(string: balance.1["iconUrl"].stringValue) {
//            coinImgView.af.setImage(withURL: url)
//        } else {
//            if (balance.0["coinType"].stringValue == chainConfig?.denom) {
//                coinImgView.image = UIImage(named: "coin_sui")
//            } else {
//                coinImgView.image = UIImage(named: "coin_default")
//            }
//        }
        
        
        symbolLabel.text = balance.0.getCoinSymbol()
        amountLabel.text = DecimalUtils.toString(balance.1.stringValue, 9)
        if (balance.0.contains(SUI_DENOM) == true) {
            coinImgView.image = UIImage(named: "coin_sui")
        } else {
            coinImgView.image = UIImage(named: "coin_default")
        }
    }
    
    func onBindEmpty() {
        self.coinImgView.image = UIImage(named: "coin_sui")
        self.symbolLabel.text = "SUI"
        self.amountLabel.text = DecimalUtils.toString("0", 9)
    }
    
}
