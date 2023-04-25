//
//  StakeVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/19.
//

import UIKit
import MaterialComponents
import SwiftyJSON
import SuiSwift
import Alamofire
import AlamofireImage
import web3swift

class StakeVC: BaseVC, BaseSheetDelegate, TxCheckSheetDelegate, PincodeDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var validatorCardView: CardView!
    @IBOutlet weak var validatorImg: UIImageView!
    @IBOutlet weak var validatorNameLabel: UILabel!
    @IBOutlet weak var votingPowerTitle: UILabel!
    @IBOutlet weak var commissionTitle: UILabel!
    @IBOutlet weak var votingPowerLabel: UILabel!
    @IBOutlet weak var commissionLabel: UILabel!
    @IBOutlet weak var toStakeAmountTextField: MDCOutlinedTextField!
    @IBOutlet weak var availableAmountTitle: UILabel!
    @IBOutlet weak var availableAmountLabel: UILabel!
    @IBOutlet weak var startEpochTitle: UILabel!
    @IBOutlet weak var startEpochLabel: UILabel!
    @IBOutlet weak var gasFeeTitle: UILabel!
    @IBOutlet weak var gasFeeLabel: UILabel!
    @IBOutlet weak var nextBtn: BaseButton!
    
    var validator: JSON!
    var available: NSDecimalNumber!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        
        validator = DataManager.shared.suiActiveValidators.filter({ $0["name"].stringValue == "Cosmostation" }).first
        if (validator == nil) {
            validator = DataManager.shared.suiActiveValidators[0]
        }
        if let balance = DataManager.shared.suiBalances.filter({ $0.0.contains(SUI_DENOM) == true }).first {
            available = balance.1.subtracting(SUI_STAKE_FEE)
        }
        
        toStakeAmountTextField.setup()
        toStakeAmountTextField.keyboardType = .decimalPad
        toStakeAmountTextField.delegate = self
        updateView()
        
        validatorCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickValidator)))
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_stake", comment: "")
        votingPowerTitle.text = NSLocalizedString("voting_power", comment: "")
        commissionTitle.text = NSLocalizedString("commission", comment: "")
        toStakeAmountTextField.label.text = NSLocalizedString("to_stake_amount", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == toStakeAmountTextField) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == toStakeAmountTextField) {
            if string == "," {
                textField.text = textField.text! + "."
                return false
            }
        }
        return true
    }
    
    func updateView() {
        //dev error
        validatorImg.image = UIImage(named: "validator_default")
        print("validator ", validator)
        if let url = validator.validatorUrl() {
            validatorImg.af.setImage(withURL: url)
        }
        validatorNameLabel.text = validator["name"].stringValue
        votingPowerLabel.text = validator["votingPower"].stringValue
        commissionLabel.text = DecimalUtils.toString(validator["commissionRate"].stringValue, 2, 2)! + "%"
        
        availableAmountLabel.text = DecimalUtils.toString(available.stringValue, 9, 9)! + " SUI"
        
        let epoch = DataManager.shared.suiSystem?["epoch"].int64Value
        startEpochLabel.text = "Epoch #" + String(epoch! + 1)
        gasFeeLabel.text = SUI_STAKE_FEE.multiplying(byPowerOf10: -9).stringValue + " SUI"
    }
    
    @objc func onClickValidator() {
        dismissKeyboard()
        let baseSheet = BaseSheet(nibName: "BaseSheet", bundle: nil)
        baseSheet.sheetResult = self
        baseSheet.sheetType = .SelectValidator
        guard let sheet = baseSheet.presentationController as? UISheetPresentationController else {
            return
        }
        sheet.detents = [.large()]
        sheet.largestUndimmedDetentIdentifier = .large
        sheet.prefersGrabberVisible = true
        present(baseSheet, animated: true)
    }
    
    func onSelectSheet(_ sheetType: SheetType?, _ result: BaseSheetResult) {
        if (sheetType == .SelectValidator) {
            validator = DataManager.shared.suiActiveValidators[result.position!]
            updateView()
        }
    }
    
    @IBAction func onClickNext(_ sender: UIButton) {
        if (onValidate()) {
            let validator = validator["name"].stringValue
            let stakeAmount = toStakeAmountTextField.text!.trimmingCharacters(in: .whitespaces) + " SUI"
            let feeAmount = SUI_STAKE_FEE.multiplying(byPowerOf10: -9).stringValue + " SUI"
            let summary = ["validator" : validator, "stakeAmount" : stakeAmount, "feeAmount" : feeAmount]
            
            let txCheckSheet = TxCheckSheet(nibName: "TxCheckSheet", bundle: nil)
            txCheckSheet.txCheckDelegate = self
            txCheckSheet.txCheckType = .TxStake
            txCheckSheet.txSummary = summary
            onStartSheet(txCheckSheet, 420)
        }
    }
    
    func onValidate() -> Bool {
        let inputAmountS = toStakeAmountTextField.text?.trimmingCharacters(in: .whitespaces)
        var inputAmount = NSDecimalNumber(string: inputAmountS, locale: Locale(identifier: "en_US"))
        if (NSDecimalNumber.notANumber == inputAmount || NSDecimalNumber.zero == inputAmount) {
            self.onShowToast(NSLocalizedString("error_invalid_amount", comment: ""))
            return false;
        }
        inputAmount = inputAmount.multiplying(byPowerOf10: 9)
        if (inputAmount.compare(available).rawValue > 0) {
            self.onShowToast(NSLocalizedString("error_invalid_amount", comment: ""))
            return false;
        }
        if (inputAmount.compare(NSDecimalNumber(string: "1000000000")).rawValue < 0) {
            self.onShowToast(NSLocalizedString("error_min_stake_amount", comment: ""))
            return false;
        }
        return true
    }
    
    func onTxConfirmed(_ sheetType: TxCheckSheetType?, _ result: Bool) {
        if (sheetType == .TxStake && result == true) {
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
                self.onStake()
            });
        }
    }
    
    func onStake() {
        onShowWait()
        let privKey = self.cAccount.privateKey!
        let pubkey = self.cAccount.publicKey!
        
        let signer = cAccount.baseAddress!.address!
        let validatorAddress = validator["suiAddress"].stringValue
        let inputAmount = toStakeAmountTextField.text?.trimmingCharacters(in: .whitespaces)
        let amount = NSDecimalNumber(string: inputAmount, locale: Locale(identifier: "en_US")).multiplying(byPowerOf10: 9).stringValue
        let gas_budget = SUI_STAKE_FEE.stringValue
//        let gas_objectId = getFeeObjectId()
//        var inputCoins = Array<String>()
//        DataManager.shared.suiObjects.forEach { object in
//            if (object["type"].stringValue.contains(SUI_DENOM) == true) {
//                inputCoins.append(object["objectId"].stringValue)
//            }
//        }
        
//        let params = JsonRpcRequest("unsafe_requestAddStake", JSON(arrayLiteral: signer, inputCoins, amount, validatorAddress, JSON.null, gas_budget))
//        print("params ", params)
//        SuiClient.shared.SuiRequest(params) { result, error in
//            print("result ", result)
//            self.onExcuteSuiTx(result, error)
//        }
        
        
        AF.request("https://us-central1-splash-wallet-60bd6.cloudfunctions.net/buildStakingRequest",
                   method: .post,
                   parameters: ["address" : signer, "validatorAddress" : validatorAddress, "gas" : gas_budget, "amount" : amount, "rpc": DataManager.shared.account?.chainConfig?.rpcEndPoint],
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
