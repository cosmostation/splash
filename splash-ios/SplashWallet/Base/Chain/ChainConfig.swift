//
//  ChainConfig.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/21.
//

import Foundation

protocol ChainConfig {
    
    var chainName: String { get }
    var chainDpName: String { get }
    var addresPrefix: String { get }
    var denom: String { get }
    var rpcEndPoint: String { get }
    
    func keynPaths() -> [KeynPath]
}


func getSupportChainConfigs() -> [ChainConfig] {
    var result = [ChainConfig]()
    result.append(ChainSui())
    result.append(ChainSuiTest())
    result.append(ChainSuiDev())
    return result
}

func getChainConfig(_ chainName: String) -> ChainConfig? {
    return getSupportChainConfigs().filter { $0.chainName == chainName }.first
}


public struct KeynPath {
    var pubkeyType: PubKeyType!
    var hdPath: String!
    
    init(_ pubkeyType: PubKeyType!, _ hdPath: String!) {
        self.pubkeyType = pubkeyType
        self.hdPath = hdPath
    }
}

enum PubKeyType: Int {
    case ETH_Keccak256 = 0
    case COSMOS_Secp256k1 = 1
    case SUI_Ed25519 = 2
    case unknown = 99
}
