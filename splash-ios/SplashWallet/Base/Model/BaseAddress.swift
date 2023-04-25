//
//  BaseAddress.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/02/25.
//

import Foundation

public class BaseAddress {
    
    var id: Int64?
    var account_id: Int64?
    var chain: String?
    var address: String?
    
    init(account_id: Int64? = nil, chain: String? = nil, address: String? = nil) {
        self.account_id = account_id
        self.chain = chain
        self.address = address
    }
    
    init(id: Int64? = nil, account_id: Int64? = nil, chain: String? = nil, address: String? = nil) {
        self.id = id
        self.account_id = account_id
        self.chain = chain
        self.address = address
    }
    
}
