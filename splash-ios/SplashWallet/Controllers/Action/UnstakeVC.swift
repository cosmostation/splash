//
//  UnstakeVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/21.
//

import UIKit
import SwiftyJSON
import SuiSwift
import Alamofire

class UnstakeVC: BaseVC, TxCheckSheetDelegate, PincodeDelegate {

    @IBOutlet weak var myStakingTableView: UITableView!
    
    var suiStaked = Array<JSON>()
    var expendedSections = Set<Int>()
    var selectedObject: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        
        myStakingTableView.delegate = self
        myStakingTableView.dataSource = self
        myStakingTableView.separatorStyle = .none
        myStakingTableView.register(UINib(nibName: "MyStakesCell", bundle: nil), forCellReuseIdentifier: "MyStakesCell")
        myStakingTableView.sectionHeaderTopPadding = 0
        
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_staked_list", comment: "")
    }
    
    func onValidateUnstake(_ indexPath: IndexPath) {
        if let suiBalance = DataManager.shared.suiBalances.filter({ $0.0.contains(SUI_DENOM) }).first {
            if (suiBalance.1.compare(SUI_UNSTAKE_FEE).rawValue < 0) {
                onShowToast(NSLocalizedString("error_not_enough_gas_fee", comment: ""))
                return
            }
            
            let staked = suiStaked[indexPath.section]
            selectedObject = staked["stakes"].arrayValue[indexPath.row]
            let validator = DataManager.shared.suiActiveValidators.filter({ $0["suiAddress"].stringValue == staked["validatorAddress"].stringValue }).first
            
            let validatorName = validator!["name"].stringValue
            let sum = selectedObject["principal"].int64Value + selectedObject["estimatedReward"].int64Value
            let unstakeAmount =  DecimalUtils.toString(String(sum), 9, 9)! + " SUI"
            let feeAmount = SUI_UNSTAKE_FEE.multiplying(byPowerOf10: -9).stringValue + " SUI"
            let summary = ["validator" : validatorName, "unstakeAmount" : unstakeAmount, "feeAmount" : feeAmount]

            let txCheckSheet = TxCheckSheet(nibName: "TxCheckSheet", bundle: nil)
            txCheckSheet.txCheckDelegate = self
            txCheckSheet.txCheckType = .TxUnstake
            txCheckSheet.txSummary = summary
            onStartSheet(txCheckSheet, 420)
        }
    }
    
    func onTxConfirmed(_ sheetType: TxCheckSheetType?, _ result: Bool) {
        if (sheetType == .TxUnstake && result == true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                let pinVC = PincodeVC(nibName: "PincodeVC", bundle: nil)
                pinVC.request = .simple
                pinVC.resultDelegate = self
                self.navigationController!.view.layer.add(self.moveinAni(), forKey: kCATransition)
                self.navigationController?.pushViewController(pinVC, animated: false)
            });
        }
    }
    
    func pincodeResponse(_ request: PincodeRequest, _ result: PincodeResult) {
        if (result == .success) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.onUnStake()
            });
        }
    }
    
    func onUnStake() {
        onShowWait()
        let privKey = self.cAccount.privateKey!
        let pubkey = self.cAccount.publicKey!
        
        let signer = cAccount.baseAddress!.address!
        let stakedSui = selectedObject["stakedSuiId"].stringValue
        let gas_budget = SUI_UNSTAKE_FEE.stringValue
//        let gas_objectId = getFeeObjectId()
        
        AF.request("https://us-central1-splash-wallet-60bd6.cloudfunctions.net/buildUnstakingRequest",
                   method: .post,
                   parameters: ["address" : signer, "objectId" : stakedSui, "gas" : gas_budget, "rpc": DataManager.shared.account?.chainConfig?.rpcEndPoint],
                   encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(let value):
                print("lamda success ")
                if let value = value, let hex = String(data: value, encoding: .utf8) {
                    let txBytes = Data(hex: hex)
                    let signedData = SuiClient.shared.sign(privKey, Data([0, 0, 0]) + txBytes)
                    SuiClient.shared.executeTransaction(txBytes, signedData, pubkey, ["showEffects": true]) { result, error in
                        print("execute result ", result)
                        guard let result = result else {
                            if let error = error {
                                print("execute error ", error)
                                self.onShowToast(NSLocalizedString("error_tx", comment: "") + error.description)
                                self.onDismissWait()
                            }
                            return
                        }
                        self.onStartTxResult(result)
                    }
                    
                } else {
                    print("lamda unsuccess")
                    self.onShowToast(NSLocalizedString("error_tx", comment: ""))
                }
                
            case .failure:
                self.onShowToast(NSLocalizedString("error_tx", comment: ""))
                self.onDismissWait()
                
            }
        }
    }
}



extension UnstakeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = MyStakesHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.valImgView.image = UIImage(named: "validator_default")
        view.valStakedLabel.text = ""
        let staked = suiStaked[section]
        if let validator = DataManager.shared.suiActiveValidators.filter({ $0["suiAddress"].stringValue == staked["validatorAddress"].stringValue }).first {
            if let url = validator.validatorUrl() {
                view.valImgView.af.setImage(withURL: url)
            }
            view.valNameLabel.text = validator["name"].stringValue + " (" + String(staked["stakes"].arrayValue.count) + ")"
        }
        
        var totalAmount:Int64 = 0
        staked["stakes"].arrayValue.forEach { stake in
            totalAmount = totalAmount + stake["principal"].int64Value
            totalAmount = totalAmount + stake["estimatedReward"].int64Value
        }
        view.valStakedLabel.text = DecimalUtils.toString(String(totalAmount), 9, 9)
        
        view.toggleBtn.tag = section
        view.toggleBtn.addTarget(self, action: #selector(self.toggleSection(sender:)), for: .touchUpInside)
        return view
    }
    
    @objc private func toggleSection(sender: UIButton) {
        let section = sender.tag
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            for row in 0..<suiStaked[section]["stakes"].arrayValue.count {
                indexPaths.append(IndexPath(row: row, section: section))
            }
            return indexPaths
        }
        if self.expendedSections.contains(section) {
            self.expendedSections.remove(section)
            self.myStakingTableView.deleteRows(at: indexPathsForSection(), with: .fade)
            sender.setImage(UIImage(named: "arrow_down"), for: .normal)
        } else {
            self.expendedSections.insert(section)
            self.myStakingTableView.insertRows(at: indexPathsForSection(), with: .fade)
            sender.setImage(UIImage(named: "arrow_up"), for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return suiStaked.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.expendedSections.contains(section) {
            return suiStaked[section]["stakes"].arrayValue.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"MyStakesCell") as? MyStakesCell
        let object = suiStaked[indexPath.section]["stakes"].arrayValue[indexPath.row]
        cell?.onBindView(object)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = suiStaked[indexPath.section]["stakes"].arrayValue[indexPath.row]
        if (object["status"].stringValue == "Pending") {
            onShowToast(NSLocalizedString("error_pending", comment: ""))
            return
        }
        onValidateUnstake(indexPath)
    }
}
