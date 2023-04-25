//
//  ChainCosmos.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/21.
//

import Foundation

class ChainCosmos: ChainConfig {
    
    let chainName = "cosmos_main"
    let chainDpName = "Cosmos Hub"
    let addresPrefix = "cosmos"
    let denom = "uatom"
    
    let HdPath0 = "m/44'/118'/0'/0/X"
    
    let rpcEndPoint = ""
    
    func keynPaths() -> [KeynPath] {
        var result = [KeynPath]()
        result.append(KeynPath.init(.COSMOS_Secp256k1, HdPath0.replacingOccurrences(of: "X", with: "0")))
        return result
    }
}
