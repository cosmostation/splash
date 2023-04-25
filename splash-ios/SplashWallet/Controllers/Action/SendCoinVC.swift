//
//  SendCoinVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/03.
//

import UIKit
import MaterialComponents
import SwiftyJSON
import SuiSwift
import AlamofireImage
import web3swift

class SendCoinVC: BaseVC, BaseSheetDelegate, TxCheckSheetDelegate, ScanDelegate, PincodeDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var availableCardView: CardView!
    @IBOutlet weak var availableImg: UIImageView!
    @IBOutlet weak var availableSymbolLabel: UILabel!
    @IBOutlet weak var availableAmountLabel: UILabel!
    @IBOutlet weak var recipientTextField: MDCOutlinedTextField!
    @IBOutlet weak var toSendAmountTextField: MDCOutlinedTextField!
    
    @IBOutlet weak var gasFeeTitle: UILabel!
    @IBOutlet weak var gasFeeLabel: UILabel!
    @IBOutlet weak var sendBtn: BaseButton!
    
    var balance: (String, NSDecimalNumber)!
    var available: NSDecimalNumber!
    var decimal: Int16 = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        
        let recipientTrailingView = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: 64, height: 32))
        recipientTrailingView.actionAddressBook = { self.onClickAddessBook() }
        recipientTrailingView.actionScan = { self.onClickScan() }
        
        recipientTextField.setup()
        recipientTextField.trailingView = recipientTrailingView
        recipientTextField.trailingViewMode = .always
        recipientTextField.delegate = self
        toSendAmountTextField.setup()
        toSendAmountTextField.keyboardType = .decimalPad
        toSendAmountTextField.delegate = self
        updateView()
        
        availableCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickAsset)))
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_send_coin", comment: "")
        recipientTextField.label.text = NSLocalizedString("recipient_address", comment: "")
        toSendAmountTextField.label.text = NSLocalizedString("to_send_amount", comment: "")
        sendBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == recipientTextField || textField == toSendAmountTextField) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == toSendAmountTextField) {
            if string == "," {
                textField.text = textField.text! + "."
                return false
            }
        }
        return true
    }
    
    func updateView() {
        gasFeeLabel.text = SUI_GLOBAL_FEE.multiplying(byPowerOf10: -9).stringValue + " SUI"
        
        available = balance.1
        if (balance.0.contains(SUI_DENOM) == true) {
            available = available.subtracting(SUI_GLOBAL_FEE)
            availableImg.image = UIImage(named: "coin_sui")
        } else {
            availableImg.image = UIImage(named: "coin_default")
        }
        
        availableSymbolLabel.text = balance.0.getCoinSymbol()
        availableAmountLabel.text = DecimalUtils.toString(balance.1.stringValue, decimal, decimal)
    }
    
    @objc func onClickAsset() {
        dismissKeyboard()
        let baseSheet = BaseSheet(nibName: "BaseSheet", bundle: nil)
        baseSheet.sheetResult = self
        baseSheet.sheetType = .SelectCoin
        onStartSheet(baseSheet)
    }
    
    func onClickAddessBook() {
        dismissKeyboard()
        let otherAccounts = BaseData.instance.selectAccounts().filter { $0.id != cAccount.id }
        let books = BaseData.instance.getAddressBooks()
        if (otherAccounts.count == 0 && books.count == 0) {
            self.onShowToast(NSLocalizedString("error_empty_address_book", comment: ""))
            return
        }
        let baseSheet = BaseSheet(nibName: "BaseSheet", bundle: nil)
        baseSheet.sheetResult = self
        baseSheet.sheetType = .SelectBook
        onStartSheet(baseSheet, 340)
    }
    
    func onSelectSheet(_ sheetType: SheetType?, _ result: BaseSheetResult) {
        if (sheetType == .SelectCoin) {
            balance = DataManager.shared.suiBalances[result.position!]
            updateView()
            
        } else if (sheetType == .SelectBook) {
            recipientTextField.text = result.address
        }
    }
    
    func onClickScan() {
        let qrScanVC = QRScanVC(nibName: "QRScanVC", bundle: nil)
        qrScanVC.scanDelegate = self
        self.navigationController?.view.layer.add(moveinAni(), forKey: kCATransition)
        self.navigationController?.pushViewController(qrScanVC, animated: false)
    }
    
    func onScanned(_ result: String) {
        recipientTextField.text = result
    }
    
    @IBAction func onClickSend(_ sender: UIButton) {
        if (onValidate()) {
            let recipient = recipientTextField.text!.trimmingCharacters(in: .whitespaces)
            let sendAmount = toSendAmountTextField.text!.trimmingCharacters(in: .whitespaces) + " " + self.availableSymbolLabel.text!
            let feeAmount = SUI_GLOBAL_FEE.multiplying(byPowerOf10: -9).stringValue + " SUI"
            let summary = ["recipient" : recipient, "sendAmount" : sendAmount, "feeAmount" : feeAmount]
            
            let txCheckSheet = TxCheckSheet(nibName: "TxCheckSheet", bundle: nil)
            txCheckSheet.txCheckDelegate = self
            txCheckSheet.txCheckType = .TxSend
            txCheckSheet.txSummary = summary
            onStartSheet(txCheckSheet, 420)
        }
    }
    
    func onValidate() -> Bool {
        let inputAddress = recipientTextField.text?.trimmingCharacters(in: .whitespaces)
        if (inputAddress?.isValidSuiAdderss() != true) {
            self.onShowToast(NSLocalizedString("error_invalid_address", comment: ""))
            return false;
        }
//        if (cAccount.baseAddress?.address == inputAddress) {
//            self.onShowToast(NSLocalizedString("error_self_send", comment: ""))
//            return false;
//        }
        
        let inputAmountS = toSendAmountTextField.text?.trimmingCharacters(in: .whitespaces)
        var inputAmount = NSDecimalNumber(string: inputAmountS, locale: Locale(identifier: "en_US"))
        if (NSDecimalNumber.notANumber == inputAmount || NSDecimalNumber.zero == inputAmount) {
            self.onShowToast(NSLocalizedString("error_invalid_amount", comment: ""))
            return false;
        }
        inputAmount = inputAmount.multiplying(byPowerOf10: decimal)
        if (inputAmount.compare(available).rawValue > 0) {
            self.onShowToast(NSLocalizedString("error_invalid_amount", comment: ""))
            return false;
        }
        
        if (balance.0.contains(SUI_DENOM) == true) {
            if ((SUI_GLOBAL_FEE.adding(inputAmount)).compare(available).rawValue > 0) {
                self.onShowToast(NSLocalizedString("error_invalid_amount", comment: ""))
                return false;
            }
        } else {
            if (inputAmount.compare(available).rawValue > 0) {
                self.onShowToast(NSLocalizedString("error_invalid_amount", comment: ""))
                return false;
            }
        }
        return true
    }
    
    func onTxConfirmed(_ sheetType: TxCheckSheetType?, _ result: Bool) {
        if (sheetType == .TxSend && result == true) {
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
                self.onSend()
            });
        }
    }
    
    func onSend() {
        onShowWait()
        
        let inputAmount = toSendAmountTextField.text?.trimmingCharacters(in: .whitespaces)
        let inputAddress = recipientTextField.text?.trimmingCharacters(in: .whitespaces)
        
        let sender = cAccount.baseAddress!.address!
        let receipient = inputAddress
        let amount = NSDecimalNumber(string: inputAmount, locale: Locale(identifier: "en_US")).multiplying(byPowerOf10: decimal).stringValue
        let gas_budget = SUI_GLOBAL_FEE.stringValue
//        let gas_objectId = getFeeObjectId()
        var inputCoins = Array<String>()
        DataManager.shared.suiObjects.forEach { object in
            if (object["type"].stringValue == balance.0) {
                inputCoins.append(object["objectId"].stringValue)
            }
        }
        
        if (balance.0.contains(SUI_DENOM) == true) {
            let params = JsonRpcRequest("unsafe_paySui", JSON(arrayLiteral: sender, inputCoins, [receipient], [amount], gas_budget))
            SuiClient.shared.SuiRequest(params) { result, error in
                print("result ", result)
                self.onExcuteSuiTx(result, error)
            }
            
        } else {
            let params = JsonRpcRequest("unsafe_pay", JSON(arrayLiteral: sender, inputCoins, [receipient], [amount], JSON.null, gas_budget))
            SuiClient.shared.SuiRequest(params) { result, error in
                print("result ", result)
                self.onExcuteSuiTx(result, error)
            }
        }
    }
    
}


