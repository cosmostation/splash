//
//  TxResultVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/11.
//

import UIKit
import SwiftyJSON

class TxResultVC: BaseVC {
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var successLayer: UIView!
    @IBOutlet weak var failLayer: UIView!
    
    @IBOutlet weak var explorerBtn: SmallBorderButton!
    @IBOutlet weak var confirmBtn: BaseButton!
    
    var TxResult: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func setLocalizedString() {
        resultTitle.text = NSLocalizedString("vc_title_tx_result", comment: "")
        confirmBtn.setTitle(NSLocalizedString("confirm", comment: ""), for: .normal)
    }
    
    func updateView() {
        if let result = TxResult {
            if (result["effects"]["status"]["status"].stringValue == "success") {
                successLayer.isHidden = false
            } else {
                failLayer.isHidden = false
            }
        }
    }

    @IBAction func onClickExplorer(_ sender: UIButton) {
        if let result = TxResult {
            var urlString = "https://explorer.sui.io/txblock/" + result["digest"].stringValue
            if (cChainConfig is ChainSuiDev) {
                urlString = urlString + "?network=devnet"
            } else if (cChainConfig is ChainSuiTest) {
                urlString = urlString + "?network=testnet"
            }
            guard let url = URL(string: urlString) else { return }
            self.onStartSafariWeb(url)
        }
    }
    
    @IBAction func onClickConfirm(_ sender: UIButton) {
        self.onStartMainTab()
    }
}
