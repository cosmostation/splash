//
//  DecimalUtils.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/02/21.
//

import Foundation


public class DecimalUtils {
    
    static func toString(_ amount: Int64?, _ decimal: Int16 = 9, _ trim: Int16 = 3) -> String? {
        return toString(String(amount!), decimal, trim)
    }
    
    static func toString(_ amount: String?, _ decimal: Int16 = 9, _ trim: Int16 = 3) -> String? {
        let nf = NumberFormatter()
        nf.roundingMode = .floor
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = Int(trim)
        nf.maximumFractionDigits = Int(trim)
        
        let number = NSDecimalNumber(string: amount)
        if (NSDecimalNumber.notANumber == number || NSDecimalNumber.zero == number) {
            return nf.string(from: NSDecimalNumber.zero)
        } else {
            let decimaled = number.multiplying(byPowerOf10: -decimal)
            return nf.string(from: decimaled)
        }
    }
}
