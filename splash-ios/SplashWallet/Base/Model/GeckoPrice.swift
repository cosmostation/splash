//
//  GeckoPrice.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/05/05.
//

import Foundation
import SwiftyJSON

public struct GeckoPrice {
    
    var price: NSDecimalNumber?
    var priceChange: NSDecimalNumber?
    
    init(_ data: JSON?) {
        self.price = NSDecimalNumber.init(value: data?["current_price"].doubleValue ?? 0)
        self.priceChange = NSDecimalNumber.init(value: data?["daily_price_change_in_percent"].doubleValue ?? 0)
    }
}
