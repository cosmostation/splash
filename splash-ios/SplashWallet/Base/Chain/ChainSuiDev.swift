//
//  ChainSuiDev.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/02/27.
//

import Foundation

class ChainSuiDev: ChainConfig {
    
    let chainName = "sui_dev"
    let chainDpName = "Devnet"
    let addresPrefix = ""
    let denom = "0x2::sui::SUI"
    
    let HdPath0 = "m/44'/784'/0'/0'/X'"
    
    let rpcEndPoint = "https://sui-devnet-kr-1.cosmostation.io"
    
    func keynPaths() -> [KeynPath] {
        var result = [KeynPath]()
        result.append(KeynPath.init(.SUI_Ed25519, HdPath0.replacingOccurrences(of: "X", with: "0")))
        return result
    }
    
}
