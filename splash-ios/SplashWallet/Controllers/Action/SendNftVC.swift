//
//  SendNftVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/08.
//

import UIKit
import MaterialComponents
import SwiftyJSON
import SuiSwift
import AlamofireImage
import web3swift

class SendNftVC: BaseVC, BaseSheetDelegate, TxCheckSheetDelegate, ScanDelegate, PincodeDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nftImgView: UIImageView!
    @IBOutlet weak var nftNameLabel: UILabel!
    @IBOutlet weak var nftObjectIdLabel: UILabel!
    @IBOutlet weak var nftTypeLabel: UILabel!
    @IBOutlet weak var recipientTextField: MDCOutlinedTextField!
    
    @IBOutlet weak var gasFeeTitle: UILabel!
    @IBOutlet weak var gasFeeLabel: UILabel!
    @IBOutlet weak var sendBtn: BaseButton!
    
    var suiNFT: JSON!
    var txFee: NSDecimalNumber!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        txFee = BaseData.instance.getSuiFee(cChainConfig, .TxSend)
        
        let recipientTrailingView = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: 64, height: 32))
        recipientTrailingView.actionAddressBook = { self.onClickAddessBook() }
        recipientTrailingView.actionScan = { self.onClickScan() }
        
        recipientTextField.setup()
        recipientTextField.trailingView = recipientTrailingView
        recipientTextField.trailingViewMode = .always
        recipientTextField.delegate = self
        updateView()
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_send_nft", comment: "")
        recipientTextField.label.text = NSLocalizedString("recipient_address", comment: "")
        sendBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == recipientTextField) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func updateView() {
        gasFeeLabel.text = txFee.multiplying(byPowerOf10: -9).stringValue + " SUI"
        
        if let url = suiNFT.nftULR() {
            nftImgView.af.setImage(withURL: url)
        } else {
            nftImgView.image = UIImage(named: "nft_default")
        }
        let name = suiNFT["content"]["fields"]["name"].stringValue
        let objectId = suiNFT["objectId"].stringValue
        let type = suiNFT["type"].stringValue
        nftNameLabel.text = name
        nftObjectIdLabel.text = objectId
        nftTypeLabel.text = type
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
        if (sheetType == .SelectBook) {
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
            let feeAmount = txFee.multiplying(byPowerOf10: -9).stringValue + " SUI"
            let nftName = suiNFT["content"]["fields"]["name"].stringValue
            let nftUrl = suiNFT.nftULR()?.absoluteString ?? ""
            let summary = ["recipient" : recipient, "nftName" : nftName, "nftUrl" : nftUrl, "feeAmount" : feeAmount]
            
            let txCheckSheet = TxCheckSheet(nibName: "TxCheckSheet", bundle: nil)
            txCheckSheet.txCheckDelegate = self
            txCheckSheet.txCheckType = .TxNFTSend
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
        return true
    }
    
    func onTxConfirmed(_ sheetType: TxCheckSheetType?, _ result: Bool) {
        if (sheetType == .TxNFTSend && result == true) {
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
                self.onSendNtf()
            });
        }
    }
    
    func onSendNtf() {
        onShowWait()

        let sender = cAccount.baseAddress!.address!
        let receipient = recipientTextField.text!.trimmingCharacters(in: .whitespaces)
        let gas_budget = txFee.stringValue
//        let gas_objectId = getFeeObjectId()
        let inputNft = suiNFT["objectId"].stringValue

        let params = JsonRpcRequest("unsafe_transferObject", JSON(arrayLiteral: sender, inputNft, JSON.null, gas_budget, receipient))
//        print("params ", params)
        SuiClient.shared.SuiRequest(params) { result, error in
            print("result ", result)
            self.onExcuteSuiTx(result, error)
        }
    }
}
