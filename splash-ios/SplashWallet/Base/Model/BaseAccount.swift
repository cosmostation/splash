//
//  BaseAccount.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/21.
//

import Foundation
import CryptoSwift
import ed25519swift
import Blake2
import Web3Core

public class BaseAccount {
    
    var id: Int64?
    var uuid: String?
    var name: String?
    var withMenmonic: Bool?
    var time: Int64?
    var favo: Bool?
    
    var mnemonic: String?
    var seed: Data?
    var privateKey: Data?
    var publicKey: Data?
    
    var baseAddress: BaseAddress?
    var chainConfig: ChainConfig?
    var keynPath: KeynPath?
    
    
    init(uuid: String? = nil, name: String? = nil, withMenmonic: Bool? = nil, time: Int64? = nil, favo: Bool? = nil, mnemonic: String? = nil) {
        self.uuid = uuid
        self.name = name
        self.withMenmonic = withMenmonic
        self.time = time
        self.favo = favo
        self.mnemonic = mnemonic
    }
    
    init(id: Int64? = nil, uuid: String? = nil, name: String? = nil, withMenmonic: Bool? = nil, time: Int64? = nil, favo: Bool? = nil) {
        self.id = id
        self.uuid = uuid
        self.name = name
        self.withMenmonic = withMenmonic
        self.time = time
        self.favo = favo
    }
    
    func prepareAccount(_ chainConfig: ChainConfig) async -> BaseAccount? {
        self.chainConfig = chainConfig
        self.keynPath = chainConfig.keynPaths()[0] //only support 0 path
        if (self.withMenmonic == true) { setSeed() }
        setChainPrivateKey(self.keynPath!)
        setChainPublicKey(self.keynPath!)
        setChainBaseAddress(await getBaseAddress(chainConfig)!)
        return self
    }
    
    func setSeed() {
        if (withMenmonic == false) { return }
        if (self.seed == nil) {
            self.setMnemonic()
            self.seed = BIP39.seedFromMmemonics(mnemonic!, password: "", language: .english)
        }
    }
    
    func setMnemonic() {
        if (self.withMenmonic == false) { return }
        if (self.mnemonic == nil) {
            self.mnemonic = BaseData.instance.getMnemonic(uuid!)
        }
    }
    
    func setPrivateKey() {
        if (self.withMenmonic == true) { return }
        if (self.privateKey == nil) {
            self.privateKey = BaseData.instance.getPrivateKey(uuid!)
        }
    }
    
    func setChainPrivateKey(_ keynPath: KeynPath) {
        if (self.withMenmonic == false) {
            self.setPrivateKey()
        } else {
            self.privateKey = getPriKeyFromSeed(self.seed!, keynPath)
        }
    }
    
    func setChainPublicKey(_ keynPath: KeynPath) {
        self.publicKey = getPubKey(self.privateKey!, keynPath)
    }
    
    func setChainBaseAddress(_ baseAddress: BaseAddress) {
        self.baseAddress = baseAddress
    }
    
    
    func getPriKeyFromSeed(_ seed: Data, _ keynPath: KeynPath) -> Data? {
        if (keynPath.pubkeyType == .SUI_Ed25519) {
            return getEd25519PriKey(seed, keynPath.hdPath)
            
        } else if (keynPath.pubkeyType == .ETH_Keccak256 || keynPath.pubkeyType == .COSMOS_Secp256k1) {
            return get256PriKey(seed, keynPath.hdPath)
            
        }
        return nil
    }
    
    func getEd25519PriKey(_ seed: Data, _ path: String) -> Data? {
        do {
            let mac = try CryptoSwift.HMAC(key: "ed25519 seed", variant: .sha2(.sha512)).authenticate(seed.bytes)
            let macSeed = Data(mac)
            
            let macSeedLeft = macSeed.subdata(in: 0..<32)
            let macSeedRight = macSeed.subdata(in: 32..<64)
            
            var seedKey = macSeedLeft
            var seedChain = macSeedRight
            
            let components = path.components(separatedBy: "/")
            var nodes = [UInt32]()
            for component in components[1 ..< components.count] {
                let index = UInt32(component.trimmingCharacters(in: CharacterSet(charactersIn: "'")))
                nodes.append(index!)
            }
            
            try nodes.forEach { node in
                let buf = Data(UInt32(0x80000000 + node).bytes)
                let databuf = Data(count: 1) + seedKey + buf
                
                let reduceMac = try CryptoSwift.HMAC(key: seedChain.bytes, variant: .sha2(.sha512)).authenticate(databuf.bytes)
                let reduceMacSeed = Data(reduceMac)
                
                seedKey = reduceMacSeed.subdata(in: 0..<32)
                seedChain = reduceMacSeed.subdata(in: 32..<64)
            }
            return seedKey
        } catch { print("error ", error) }
        return nil
    }
    
    func get256PriKey(_ seed: Data, _ path: String) -> Data? {
        return (HDNode(seed: seed)?.derive(path: path, derivePrivateKey: true)!.privateKey)!
    }
    
    
    func getPubKey(_ privateKey: Data, _ keynPath: KeynPath) -> Data? {
        if (keynPath.pubkeyType == .SUI_Ed25519) {
            return getEd25519PubKey(privateKey)
            
        } else if (keynPath.pubkeyType == .ETH_Keccak256 || keynPath.pubkeyType == .COSMOS_Secp256k1) {
            return get256PubKey(privateKey)
            
        }
        return nil
    }
    
    func getEd25519PubKey(_ privateKey: Data) -> Data {
        return Data(Ed25519.calcPublicKey(secretKey: [UInt8](privateKey)))
    }
    
    func get256PubKey(_ privateKey: Data) -> Data {
        return SECP256K1.privateToPublic(privateKey: privateKey, compressed: true)!
    }
    
    func getAddress(_ publicKey: Data, _ keynPath: KeynPath, _ prefix: String? = nil) -> String {
        if (keynPath.pubkeyType == .SUI_Ed25519) {
            let data = Data([UInt8](Data(count: 1)) + publicKey)
            let hash = try! Blake2b.hash(size: 32, data: data)
            return "0x" + hash.toHexString()

        } else if (keynPath.pubkeyType == .ETH_Keccak256) {
            return Web3Core.Utilities.publicToAddressString(publicKey)!

        } else if (keynPath.pubkeyType == .COSMOS_Secp256k1) {
            let ripemd160 = try! RIPEMD160.hash(message: publicKey.sha256())
            return try! SegwitAddrCoder.shared.encode(prefix!, ripemd160)
        }
        return ""
    }
    
    func getBaseAddress(_ chainConfig: ChainConfig) async -> BaseAddress? {
        if let baseAddress = BaseData.instance.selectAddress(self.id!, chainConfig.chainName) {
            return baseAddress
            
        } else {
            if let baseAccount = BaseData.instance.selectAccountById(self.id!) {
                let accountType = chainConfig.keynPaths()[0]  //only support 0 path
                var privateKey: Data!
                if (baseAccount.withMenmonic == true) {
                    let mnemonic = BaseData.instance.getMnemonic(baseAccount.uuid!)
                    let seed = BIP39.seedFromMmemonics(mnemonic, password: "", language: .english)!
                    privateKey = getPriKeyFromSeed(seed, accountType)
                } else {
                    privateKey = BaseData.instance.getPrivateKey(baseAccount.uuid!)
                }
                
                let publicKey = getPubKey(privateKey, accountType)
                let address = getAddress(publicKey!, accountType, chainConfig.addresPrefix)
                
                let baseAddress = BaseAddress.init(account_id: self.id!, chain: chainConfig.chainName, address: address)
                _ = BaseData.instance.insertAddress(baseAddress)
                return BaseData.instance.selectAddress(self.id!, chainConfig.chainName)
            }
        }
        return nil
    }
    
}

extension UInt32 {
    var bytes: [UInt8] {
        var bend = bigEndian
        let count = MemoryLayout<UInt32>.size
        let bytePtr = withUnsafePointer(to: &bend) {
            $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                UnsafeBufferPointer(start: $0, count: count)
            }
        }
        return Array(bytePtr)
    }
}


