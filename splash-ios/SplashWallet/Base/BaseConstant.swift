//
//  BaseConstant.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/18.
//

import Foundation
import UIKit


let KEY_PINCODE_UUID                    = "KEY_PINCODE_UUID"
let KEY_APP_LOCK                        = "KEY_APP_LOCK"
let KEY_BIO_AUTH                        = "KEY_BIO_AUTH"
let KEY_RECENT_ACCOUNT                  = "KEY_RECENT_ACCOUNT"
let KEY_RECENT_CHAIN                    = "KEY_RECENT_CHAIN"
let KEY_THEME                           = "KEY_THEME"
let KEY_LANGUAGE                        = "KEY_LANGUAGE"
let KEY_ADDRESS_BOOK                    = "KEY_ADDRESS_BOOK"

let KEY_SUI_FEES                        = "KEY_SUI_FEES"


let font1 = UIFont(name: "Pretendard-Bold", size: 36.0)
let font2 = UIFont(name: "Pretendard-SemiBold", size: 24.0)
let font3 = UIFont(name: "Pretendard-SemiBold", size: 20.0)
let font4 = UIFont(name: "Pretendard-SemiBold", size: 18.0)
let font5 = UIFont(name: "Pretendard-SemiBold", size: 16.0)
let font6 = UIFont(name: "Pretendard-SemiBold", size: 14.0)
let font7 = UIFont(name: "Pretendard-Medium", size: 14.0)
let font8 = UIFont(name: "Pretendard-SemiBold", size: 12.0)


public enum Theme: Int {
    case System = 0
    case Light = 1
    case Dark = 2
    
    public static func getThemes() -> [Theme] {
        var result = Array<Theme>()
        result.append(.System)
        result.append(.Light)
        result.append(.Dark)
        return result
    }
    
    var themeStyle: UIUserInterfaceStyle {
        switch self {
        case .System: return .unspecified
        case .Light: return .light
        case .Dark: return .dark
        }
    }
    
    var description: String {
        switch self {
        case .System: return "System"
        case .Light: return "Light Mode"
        case .Dark: return "Dark Mode"
        }
    }
}

public enum Language: Int {
    case System = 0
    case English = 1
    case Korean = 2
    
    public static func getLanguages() -> [Language] {
        var result = Array<Language>()
        result.append(.System)
        result.append(.English)
        result.append(.Korean)
        return result
    }
    
    var languageCode: String {
        switch self {
        case .System: return Locale.current.languageCode ?? ""
        case .English: return "en"
        case .Korean: return "ko"
        }
    }
    
    var description: String {
        switch self {
        case .System: return "System"
        case .English: return "English(United States)"
        case .Korean: return "한국어(대한민국)"
        }
    }
}
