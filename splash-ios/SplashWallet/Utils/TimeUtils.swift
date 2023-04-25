//
//  TimeUtils.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/02/24.
//

import Foundation

public class TimeUtils {
    
    static func toString(_ milliseconds: Int) -> String {
        let localFormatter = DateFormatter()
        localFormatter.dateFormat = NSLocalizedString("HH:mm:ss", comment: "")
        return localFormatter.string(from: Date(milliseconds: milliseconds))
    }
    
    static func getDay(_ milliseconds: Int) -> String {
        let localFormatter = DateFormatter()
        localFormatter.dateFormat = NSLocalizedString("MMMM dd, yyyy", comment: "")
        return localFormatter.string(from: Date(milliseconds: milliseconds))
    }
}
