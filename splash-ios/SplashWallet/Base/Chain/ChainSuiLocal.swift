//
//  ChainSuiLocal.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/02/27.
//

import Foundation

class ChainSuiLocal: ChainConfig {
    
    let chainName = "sui_local"
    let chainDpName = "Localnet"
    let addresPrefix = ""
    let denom = "0x2::sui::SUI"
    
    let HdPath0 = "m/44'/784'/0'/0'/X'"
    
    let rpcEndPoint = "http://127.0.0.1:9000/"
    
    func keynPaths() -> [KeynPath] {
        var result = [KeynPath]()
        result.append(KeynPath.init(.SUI_Ed25519, HdPath0.replacingOccurrences(of: "X", with: "0")))
        return result
    }
    
}
