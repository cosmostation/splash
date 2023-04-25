//
//  BaseData.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/15.
//

import Foundation
import SQLite
import SwiftKeychainWrapper
import UIKit

final class BaseData : NSObject{
    
    static let instance = BaseData()
    
    var database: Connection!
    
    public override init() {
        super.init();
        if database == nil {
            self.initdb();
        }
    }
    
    func initdb() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            var fileUrl = documentDirectory.appendingPathComponent("data").appendingPathExtension("sqlite3")

            let database = try Connection(fileUrl.path)
            self.database = database
            
            let createAccountTable = ACCOUNT_TABLE.create(ifNotExists: true) { (table) in
                table.column(ACCOUNT_ID, primaryKey: true)
                table.column(ACCOUNT_UUID)
                table.column(ACCOUNT_NAME)
                table.column(ACCOUNT_WITH_MNEMONIC)
                table.column(ACCOUNT_TIME)
                table.column(ACCOUNT_FAVO)
            }
            try self.database.run(createAccountTable)
            
            let createAddressTable = ADDRESS_TABLE.create(ifNotExists: true) { (table) in
                table.column(ADDRESS_ID, primaryKey: true)
                table.column(ADDRESS_ACCOUNT_ID)
                table.column(ADDRESS_CHAIN)
                table.column(ADDRESS_ADDRESS)
            }
            try self.database.run(createAddressTable)
            
            do {
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try fileUrl.setResourceValues(resourceValues)
                
            } catch { print("excludedFromBackup ", error) }
        } catch { print("initdb ", error) }
    }
    
    public func selectAccounts() -> [BaseAccount] {
        var result = [BaseAccount]()
        do {
            for accountBD in try database.prepare(ACCOUNT_TABLE) {
                result.append(BaseAccount(id: accountBD[ACCOUNT_ID], uuid: accountBD[ACCOUNT_UUID], name: accountBD[ACCOUNT_NAME],
                                          withMenmonic: accountBD[ACCOUNT_WITH_MNEMONIC], time: accountBD[ACCOUNT_TIME], favo: accountBD[ACCOUNT_FAVO]))
            }
        } catch { print("selectAccounts ", error) }
        return result
    }
    
    public func selectAccountById(_ id: Int64) -> BaseAccount? {
        return selectAccounts().filter { $0.id == id }.first
    }
    
    public func insertAccount(_ account: BaseAccount) -> Int64 {
        let insertAccount = ACCOUNT_TABLE.insert(ACCOUNT_UUID <- account.uuid!,
                                                 ACCOUNT_NAME <- account.name!,
                                                 ACCOUNT_WITH_MNEMONIC <- account.withMenmonic!,
                                                 ACCOUNT_TIME <- account.time!,
                                                 ACCOUNT_FAVO <- account.favo!)
        do {
            return try database.run(insertAccount)
        } catch {
            print("insertAccount ", error)
            return -1
        }
    }
    
    public func updateAccount(_ baseAccount: BaseAccount) -> Int64 {
        let target = ACCOUNT_TABLE.filter(ACCOUNT_ID == baseAccount.id!)
        do {
            return try Int64(database.run(target.update(ACCOUNT_NAME <- baseAccount.name!)))
        } catch {
            return -1
        }
    }
    
    public func deleteAccount(_ account: BaseAccount) -> Int {
        self.deleteAddressByAccountId(account.id!)
        let query = ACCOUNT_TABLE.filter(ACCOUNT_ID == account.id!)
        do {
            return try database.run(query.delete())
        } catch {
            print("deleteAccount ", error)
            return -1
        }
    }
    
    public func selectAddresses() -> [BaseAddress] {
        var result = [BaseAddress]()
        do {
            for addressBD in try database.prepare(ADDRESS_TABLE) {
                result.append(BaseAddress.init(id: addressBD[ADDRESS_ID], account_id: addressBD[ADDRESS_ACCOUNT_ID],
                                               chain: addressBD[ADDRESS_CHAIN], address: addressBD[ADDRESS_ADDRESS]))
            }
        } catch { print("selectAddresses ", error) }
        return result
    }
    
    public func selectAddress(_ accountId: Int64, _ chain: String) -> BaseAddress? {
        return selectAddresses().filter { $0.account_id == accountId && $0.chain == chain }.first
    }
    
    public func selectAddressById(_ id: Int64) -> BaseAddress? {
        return selectAddresses().filter { $0.id == id }.first
    }
    
    public func selectAddressesByChain(_ chain: String) -> [BaseAddress] {
        return selectAddresses().filter { $0.chain == chain }
    }
    
    public func insertAddress(_ address: BaseAddress) -> Int64 {
        let insertAddress = ADDRESS_TABLE.insert(ADDRESS_ACCOUNT_ID <- address.account_id!,
                                                 ADDRESS_CHAIN <- address.chain!,
                                                 ADDRESS_ADDRESS <- address.address!)
        do {
            return try database.run(insertAddress)
        } catch {
            print("insertAddress ", error)
            return -1
        }
    }
    
    public func deleteAddress(_ address: BaseAddress) -> Int {
        let query = ADDRESS_TABLE.filter(ADDRESS_ID == address.id!)
        do {
            return try database.run(query.delete())
        } catch {
            print("deleteAddress ", error)
            return -1
        }
    }
    
    public func deleteAddressByAccountId(_ accountId: Int64) {
        let query = ADDRESS_TABLE.filter(ADDRESS_ACCOUNT_ID == accountId)
        do {
            try database.run(query.delete())
        } catch { }
    }
    

    
    func setUUID(_ uuid : String) {
        UserDefaults.standard.set(uuid, forKey: KEY_PINCODE_UUID)
    }
    
    func getUUID() -> String {
        return UserDefaults.standard.string(forKey: KEY_PINCODE_UUID) ?? ""
    }
    
    func hasPinCode() -> Bool {
        if (getUUID() == "") { return false }
        return KeychainWrapper.standard.hasValue(forKey: getUUID())
    }
    
    func setPinCode(_ pinCode: String) -> Bool {
        return KeychainWrapper.standard.set(pinCode, forKey: getUUID(), withAccessibility: .afterFirstUnlockThisDeviceOnly, isSynchronizable: false)
    }
    
    func getPinCode() -> String? {
        if (KeychainWrapper.standard.hasValue(forKey: getUUID())) {
            return KeychainWrapper.standard.string(forKey: getUUID())
        }
        return nil
    }
    
    func setMnemonic(_ uuid: String, _ menmonic: String) -> Bool {
        return KeychainWrapper.standard.set(menmonic, forKey: uuid, withAccessibility: .afterFirstUnlockThisDeviceOnly, isSynchronizable: false)
    }
    
    func getMnemonic(_ uuid: String) -> String {
        if (KeychainWrapper.standard.hasValue(forKey: uuid)) {
            return KeychainWrapper.standard.string(forKey: uuid)!
        }
        return ""
    }
    
    func deleteMenmonic(_ uuid: String) {
        KeychainWrapper.standard.removeObject(forKey: uuid)
    }
    
    func setPrivateKey(_ uuid: String, _ privateKey: String) -> Bool {
        return KeychainWrapper.standard.set(privateKey, forKey: uuid, withAccessibility: .afterFirstUnlockThisDeviceOnly, isSynchronizable: false)
    }
    
    func getPrivateKey(_ uuid: String) -> Data? {
        if (KeychainWrapper.standard.hasValue(forKey: uuid)) {
            return Data.fromHex(KeychainWrapper.standard.string(forKey: uuid)!)
        }
        return nil
    }
    
    func deletePrivateKey(_ uuid: String) {
        KeychainWrapper.standard.removeObject(forKey: uuid)
    }
    
    func setAppLock(_ using : Bool) {
        UserDefaults.standard.set(using, forKey: KEY_APP_LOCK)
    }
    
    func getAppLock() -> Bool {
        return UserDefaults.standard.bool(forKey: KEY_APP_LOCK)
    }
    
    func setBioAuth(_ using : Bool) {
        UserDefaults.standard.set(using, forKey: KEY_BIO_AUTH)
    }
    
    func getBioAuth() -> Bool {
        return UserDefaults.standard.bool(forKey: KEY_BIO_AUTH)
    }
    
    func setRecentAccount(_ id : Int64) {
        UserDefaults.standard.set(id, forKey: KEY_RECENT_ACCOUNT)
    }
    
    func getRecentAccount() -> BaseAccount? {
        return selectAccountById(Int64(UserDefaults.standard.integer(forKey: KEY_RECENT_ACCOUNT)))
    }
    
    func setRecentChain(_ chainConfig: ChainConfig) {
        UserDefaults.standard.set(chainConfig.chainName, forKey: KEY_RECENT_CHAIN)
    }

    func getRecentChain() -> ChainConfig {
        if let rawChainName = UserDefaults.standard.string(forKey: KEY_RECENT_CHAIN),
            let chainConfig = getChainConfig(rawChainName) {
            return chainConfig
        }
        return ChainSuiTest()
    }
    
    func setLanguage(_ lang: Int) {
        UserDefaults.standard.set(lang, forKey: KEY_LANGUAGE)
    }
    
    func getLanguage() -> Int {
        return UserDefaults.standard.integer(forKey: KEY_LANGUAGE)
    }
    
    func setTheme(_ theme: Int) {
        UserDefaults.standard.set(theme, forKey: KEY_THEME)
    }
    
    func getTheme() -> Int {
        return UserDefaults.standard.integer(forKey: KEY_THEME)
    }
    
    func setAddressBooks(_ addresses: [AddressBook]) {
        if let encoded = try? JSONEncoder().encode(addresses) {
            UserDefaults.standard.setValue(encoded, forKey: KEY_ADDRESS_BOOK)
        }
    }
    
    func getAddressBooks() -> [AddressBook] {
        if let savedData = UserDefaults.standard.object(forKey: KEY_ADDRESS_BOOK) as? Data {
            if let result = try? JSONDecoder().decode([AddressBook].self, from: savedData) {
                return result
            }
        }
        return []
    }
    
    func isRequiredUnlock() -> Bool {
        getAppLock() && hasPinCode()
    }
    
    
    
    let ACCOUNT_TABLE           = Table("base_account")
    let ACCOUNT_ID              = Expression<Int64>("id")
    let ACCOUNT_UUID            = Expression<String>("uuid")
    let ACCOUNT_NAME            = Expression<String>("name")
    let ACCOUNT_WITH_MNEMONIC   = Expression<Bool>("withMnemonic")
    let ACCOUNT_TIME            = Expression<Int64>("time")
    let ACCOUNT_FAVO            = Expression<Bool>("favo")
    
    let ADDRESS_TABLE           = Table("base_address")
    let ADDRESS_ID              = Expression<Int64>("id")
    let ADDRESS_ACCOUNT_ID      = Expression<Int64>("account_id")
    let ADDRESS_CHAIN           = Expression<String>("chain")
    let ADDRESS_ADDRESS         = Expression<String>("address")
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    var StringmillisecondsSince1970:String {
        return String((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    var Stringmilli3MonthAgo:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0) - TimeInterval(7776000000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
