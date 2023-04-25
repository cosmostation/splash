//
//  AddressBook.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/12.
//

import Foundation

public struct AddressBook: Codable {
    var name: String?
    var chainType: String?
    var address: String?
    var memo: String?
}
