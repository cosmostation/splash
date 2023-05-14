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
        let suiPrice = BaseData.instance.geckoPrice?.price ?? NSDecimalNumber.zero
        let suiPriceChange = BaseData.instance.geckoPrice?.priceChange ?? NSDecimalNumber.zero
        
        priceLabel.text = "$" + DecimalUtils.toString(suiPrice.stringValue, 0, 2)!
        if (suiPriceChange.compare(NSDecimalNumber.zero).rawValue >= 0) {
            priceChangeLabel.text = "+" + DecimalUtils.toString(suiPriceChange.stringValue, 0, 2)! + "%"
            priceChangeLabel.textColor = .green
        } else {
            priceChangeLabel.text = DecimalUtils.toString(suiPriceChange.stringValue, 0, 2)! + "%"
            priceChangeLabel.textColor = .red
        }
        
        if (position == 0) {
            let suiAmount = DataManager.shared.getSuiAmount()
            let suiValue = suiAmount.multiplying(byPowerOf10: -9).multiplying(by: suiPrice)
            symbolLabel.text = "SUI"
            amountLabel.text = DecimalUtils.toString(suiAmount.stringValue, 9)
            valueLabel.text = "$" + DecimalUtils.toString(suiValue.stringValue, 0, 2)!
            coinImgView.image = UIImage(named: "coin_sui")
        } else {
            let stakedSuiAmount = DataManager.shared.getSuiStakedAmount()
            let stakedSuiValue = stakedSuiAmount.multiplying(byPowerOf10: -9).multiplying(by: suiPrice)
            symbolLabel.text = "Staked SUI"
            amountLabel.text = DecimalUtils.toString(stakedSuiAmount.stringValue, 9)
            valueLabel.text = "$" + DecimalUtils.toString(stakedSuiValue.stringValue, 0, 2)!
            coinImgView.image = UIImage(named: "coin_sui_staked")
        }
    }
    
    func onBindBalance(_ chainConfig: ChainConfig?, _ balance: (String, NSDecimalNumber)) {
        if let meta = DataManager.shared.suiCoinMeta[balance.0] {
            symbolLabel.text = meta["symbol"].stringValue
            amountLabel.text = DecimalUtils.toString(balance.1.stringValue, meta["decimals"].int16Value)
            if let iconUrl = meta["iconUrl"].string, let url = URL(string: iconUrl) {
                coinImgView.af.setImage(withURL: url)
            } else {
                coinImgView.image = UIImage(named: "coin_default")
            }
        } else {
            symbolLabel.text = balance.0.getCoinSymbol()
            amountLabel.text = DecimalUtils.toString(balance.1.stringValue, 9)
            coinImgView.image = UIImage(named: "coin_default")
        }
        
        priceLabel.text = "$" + DecimalUtils.toString(NSDecimalNumber.zero.stringValue, 0, 2)!
        priceChangeLabel.text = "+" + DecimalUtils.toString(NSDecimalNumber.zero.stringValue, 0, 2)! + "%"
        priceChangeLabel.textColor = .green
        valueLabel.text = "$" + DecimalUtils.toString(NSDecimalNumber.zero.stringValue, 0, 2)!
    }
    
}
