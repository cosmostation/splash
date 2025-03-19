//
//  DataManager.swift
//  SplashWallet
//
//  Created by y on 2023/02/10.
//

import Foundation
import SwiftyJSON
import SuiSwift
import Alamofire

class DataManager {
    static let shared = DataManager()
    
    var account: BaseAccount?
    var suiSystem: JSON?
    var suiBalances = Array<(String, NSDecimalNumber)>()
    var suiStaked = Array<JSON>()
    var suiObjects = Array<JSON>()
    var suiFromTxs = Array<JSON>()
    var suiToTxs = Array<JSON>()
    var suiTxs = Array<JSON>()
    var suiCoinMeta: [String: JSON] = [:]
    var suiActiveValidators = Array<JSON>()
    var openDappVCAction: (() -> ())? = nil
    
    func loadAll() {
        let group = DispatchGroup()
        
        if (account?.chainConfig is ChainSui) {
            SuiClient.shared.setConfig(.mainnet, account?.chainConfig?.rpcEndPoint)
            onFetchSuiData(group)

        } else if (account?.chainConfig is ChainSuiDev) {
            SuiClient.shared.setConfig(.devnet, account?.chainConfig?.rpcEndPoint)
            onFetchSuiData(group)

        } else if (account?.chainConfig is ChainSuiTest) {
            SuiClient.shared.setConfig(.testnet, account?.chainConfig?.rpcEndPoint)
            onFetchSuiData(group)
        }
        
        group.notify(queue: .main) {
            if (self.account?.chainConfig is ChainSui ||
                self.account?.chainConfig is ChainSuiDev ||
                self.account?.chainConfig is ChainSuiTest) {
                
                self.suiSystem?["activeValidators"].arrayValue.forEach { validator in
                    self.suiActiveValidators.append(validator)
                }
                self.suiActiveValidators.sort {
                    if ($0["name"].stringValue == "Cosmostation") { return true }
                    if ($1["name"].stringValue == "Cosmostation") { return false }
                    return $0["votingPower"].intValue > $1["votingPower"].intValue ? true : false
                }
                
                self.suiBalances = self.getAllBalance()
                self.suiBalances.sort {
                    if ($0.0.contains(SUI_DENOM) == true) { return true }
                    if ($1.0.contains(SUI_DENOM) == true) { return false }
                    return false
                }
//                print("suiActiveValidators ", self.suiActiveValidators.count)
//                print("suiObjects ", self.suiObjects.count)
//                print("suiBalances ", self.suiBalances.count)
//                print("suiToTxs ", self.suiToTxs.count)
//                print("suiFromTxs ", self.suiFromTxs.count)
//                print("suiTxs ", self.suiTxs.count)
//                print("suiObjects ", self.suiObjects)
            }
            NotificationCenter.default.post(name: Notification.Name("DataFetched"), object: nil, userInfo: nil)
            self.onFetchSuiCoinMeta()
        }
    }
    
    func onFetchSuiData(_ group: DispatchGroup) {
        suiSystem = nil
        suiBalances.removeAll()
        suiStaked.removeAll()
        suiObjects.removeAll()
        suiFromTxs.removeAll()
        suiToTxs.removeAll()
        suiTxs.removeAll()
        suiCoinMeta.removeAll()
        suiActiveValidators.removeAll()
        
        BaseData.instance.geckoPrice = nil
        
        if let address = account?.baseAddress?.address {
            onFetchSystem(group)
            onFetchStakeInfo(group, address)
            onFetchOwnedObjects(group, address)
//            onFetchHistory(group, address)
            onFetchFee(group)
            
            if (self.account?.chainConfig is ChainSui) {
                onFetchPrice(group)
            }

        }
    }
    
    func onFetchSystem(_ group: DispatchGroup) {
        group.enter()
        let systemStateParams = JsonRpcRequest("suix_getLatestSuiSystemState", JSON())
        SuiClient.shared.SuiRequest(systemStateParams) { state, error in
            self.suiSystem = state
            group.leave()
        }
    }
    
//    func onFetchAllBalance(_ group: DispatchGroup, _ address: String) {
//        group.enter()
//        let allBalancesParams = JsonRpcRequest("suix_getAllBalances", JSON(arrayLiteral: address))
//        SuiClient.shared.SuiRequest(allBalancesParams) { balances, error in
//            balances?.forEach({ _, balance in
//            })
//            group.leave()
//        }
//    }
    
    func onFetchSuiCoinMeta() {
        self.suiBalances.forEach { denom, balance in
            let param = JsonRpcRequest("suix_getCoinMetadata", JSON(arrayLiteral: denom.getCoinType()))
            SuiClient.shared.SuiRequest(param) { result, error in
                if let result = result {
                    self.suiCoinMeta[denom] = result
                    NotificationCenter.default.post(name: Notification.Name("DataFetched"), object: nil, userInfo: nil)
                }
            }
        }
    }
    
    func onFetchStakeInfo(_ group: DispatchGroup, _ address: String) {
        group.enter()
        let getStakesParams = JsonRpcRequest("suix_getStakes", JSON(arrayLiteral: address))
        SuiClient.shared.SuiRequest(getStakesParams) { stakes, error in
            stakes?.arrayValue.forEach({ stake in
                self.suiStaked.append(stake)
            })
            group.leave()
        }
    }
    
    func onFetchOwnedObjects(_ group: DispatchGroup, _ address: String) {
        group.enter()
        let ownedObjectsParams = JsonRpcRequest("suix_getOwnedObjects",
                                                JSON(arrayLiteral: address, ["filter": nil, "options":["showContent":true, "showDisplay":true,  "showType":true]]))
        SuiClient.shared.SuiRequest(ownedObjectsParams) { result, error in
            result?["data"].arrayValue.forEach { [weak self] data in
                guard let self else { return }
                suiObjects.append(data["data"])
            }
            group.leave()
        }
    }
    
    func onFetchHistory(_ address: String) {
        let group = DispatchGroup()
        group.enter()
        let toTxsParams = JsonRpcRequest("suix_queryTransactionBlocks",
                                         JSON(arrayLiteral: ["filter": ["ToAddress": address], "options": ["showEffects": true, "showInput":true, "showBalanceChanges":true]],
                                              JSON.null, 50, true))
        SuiClient.shared.SuiRequest(toTxsParams) { result, error in
            result?["data"].arrayValue.forEach { data in
                self.suiToTxs.append(data)
            }
            group.leave()
        }
        
        group.enter()
        let fromTxsParams = JsonRpcRequest("suix_queryTransactionBlocks",
                                           JSON(arrayLiteral: ["filter": ["FromAddress": address], "options": ["showEffects": true, "showInput":true, "showBalanceChanges":true]],
                                                JSON.null, 50, true))
        SuiClient.shared.SuiRequest(fromTxsParams) { result, error in
            result?["data"].arrayValue.forEach { data in
                self.suiFromTxs.append(data)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.suiTxs.append(contentsOf: self.suiToTxs)
            self.suiFromTxs.forEach { fromTx in
                if (self.suiTxs.filter({ $0["digest"].stringValue == fromTx["digest"].stringValue }).first == nil) {
                    self.suiTxs.append(fromTx)
                }
            }
            self.suiTxs.sort {
                return $0["checkpoint"].int64Value > $1["checkpoint"].int64Value
            }
            NotificationCenter.default.post(name: Notification.Name("HistoryFetched"), object: nil, userInfo: nil)
        }
    }
    
    func onFetchFee(_ group: DispatchGroup) {
        group.enter()
        AF.request("https://raw.githubusercontent.com/cosmostation/splash/main/resources/fee.json", method: .get)
            .responseDecodable(of: JSON.self) { response in
            switch response.result {
            case .success(let value):
                BaseData.instance.setSuiFees(value)
            case .failure:
                print("dynamic fee error")
            }
            group.leave()
        }
    }
    
    func onFetchPrice(_ group: DispatchGroup) {
        group.enter()
        AF.request("https://front.api.mintscan.io/v10/utils/market/price/coingecko_id/sui?currency=usd", method: .get)
            .responseDecodable(of: JSON.self) { response in
            switch response.result {
            case .success(let value):
                BaseData.instance.geckoPrice = GeckoPrice(value)
            case .failure:
                print("price error")
            }
            group.leave()
        }
    }
    
    func getAllBalance() -> Array<(String, NSDecimalNumber)> {
        var result = Array<(String, NSDecimalNumber)>()
        suiObjects.forEach { object in
            let type = object["type"].stringValue
            if (type.starts(with: "0x2::coin::Coin")) {
                if let index = result.firstIndex(where: { $0.0 == type }) {
                    let alreadyAmount = result[index].1
                    let sumAmount = alreadyAmount.adding(NSDecimalNumber.init(string:  object["content"]["fields"]["balance"].stringValue))
                    result[index] = (type, sumAmount)
                    
                } else {
                    let newAmount = NSDecimalNumber.init(string:  object["content"]["fields"]["balance"].stringValue)
                    result.append((type, newAmount))
                }
            }
        }
        return result
    }
    
    func getSuiAmount() -> NSDecimalNumber {
        if let suiCoin = getAllBalance().filter({ $0.0.contains(SUI_DENOM) == true }).first {
            return suiCoin.1
        }
        return NSDecimalNumber.zero
    }
    
    func getSuiStakedAmount() -> NSDecimalNumber {
        var staked = NSDecimalNumber.zero
        var earned = NSDecimalNumber.zero
        suiStaked.forEach { suiStaked in
            suiStaked["stakes"].arrayValue.forEach { stakes in
                staked = staked.adding(NSDecimalNumber(value: stakes["principal"].int64Value))
                earned = earned.adding(NSDecimalNumber(value: stakes["estimatedReward"].int64Value))
            }
        }
        return staked.adding(earned)
    }
    
    
    func onFaucet(_ address: String) async -> JSON? {
        return try? await SuiClient.shared.faucet(address)
    }
}

extension String {
    //TODO not pass check sum
    func isValidSuiAdderss() -> Bool {
        if (self.starts(with: "0x") && self.count == 66) {
            return true
        }
        return false
    }
    
    func getCoinType() -> String {
        if let s1 = self.components(separatedBy: "<").last,
           let s2 = s1.components(separatedBy: ">").first {
            return s2
        }
        return ""
    }
    
    func getCoinSymbol() -> String {
        if let s1 = self.components(separatedBy: "<").last,
           let s2 = s1.components(separatedBy: ">").first,
           let symbol = s2.components(separatedBy: "::").last {
            return symbol
        }
        return ""
    }
    
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
