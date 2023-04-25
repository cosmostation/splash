//
//  ChainSui.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/21.
//

import Foundation

class ChainSui: ChainConfig {
    
    let chainName = "sui_main"
    let chainDpName = "Mainnet"
    let addresPrefix = ""
    let denom = "0x2::sui::SUI"
    
    let HdPath0 = "m/44'/784'/0'/0'/X'"
    
    let rpcEndPoint = ""
    
    func keynPaths() -> [KeynPath] {
        var result = [KeynPath]()
        result.append(KeynPath.init(.SUI_Ed25519, HdPath0.replacingOccurrences(of: "X", with: "0")))
        return result
    }
    
}

let SUI_DENOM = "0x2::sui::SUI"
