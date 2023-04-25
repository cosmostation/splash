//
//  ChainKava.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/21.
//

import Foundation


class ChainKava: ChainConfig {
    
    let chainName = "kava_main"
    let chainDpName = "Kava"
    let addresPrefix = "kava"
    let denom = "ukava"
    
    let HdPath0 = "m/44'/459'/0'/0/X"
    let HdPath1 = "m/44'/118'/0'/0/X"
    let HdPath2 = "m/44'/60'/0'/0/X"
    
    let rpcEndPoint = ""
    
    func keynPaths() -> [KeynPath] {
        var result = [KeynPath]()
        result.append(KeynPath.init(.COSMOS_Secp256k1, HdPath0.replacingOccurrences(of: "X", with: "0")))
        result.append(KeynPath.init(.COSMOS_Secp256k1, HdPath1.replacingOccurrences(of: "X", with: "0")))
        result.append(KeynPath.init(.ETH_Keccak256, HdPath2.replacingOccurrences(of: "X", with: "0")))
        return result
    }
}
