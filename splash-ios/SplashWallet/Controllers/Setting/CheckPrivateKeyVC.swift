//
//  CheckPrivateKeyVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/06.
//

import UIKit

class CheckPrivateKeyVC: BaseVC {
    
    @IBOutlet weak var privateKeyTitle: UILabel!
    @IBOutlet weak var privateKeyCardView: CardView!
    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var confirmBtn: BaseButton!
    
    var toShowAccount: BaseAccount!
    var keynPath: KeynPath!
    var privateKey: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        keynPath = DataManager.shared.account?.chainConfig?.keynPaths()[0]
        
        self.onShowWait()
        Task {
            if (self.toShowAccount.withMenmonic == true) { self.toShowAccount.setSeed() }
            toShowAccount.setChainPrivateKey(keynPath!)
            privateKey = "0x" + toShowAccount.privateKey!.toHexString()
            privateKeyLabel.text = privateKey
            self.onDismissWait()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCopyPrivateKey))
        tap.cancelsTouchesInView = false
        privateKeyCardView.addGestureRecognizer(tap)
    }
    
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_check_private_key", comment: "")
        privateKeyTitle.text = NSLocalizedString("private_key", comment: "")
        confirmBtn.setTitle(NSLocalizedString("confirm", comment: ""), for: .normal)
    }
    
    @objc func onCopyPrivateKey() {
        UIPasteboard.general.string = privateKey
        onShowToast(NSLocalizedString("private_key_copied", comment: ""))
    }

    @IBAction func onClickConfirm(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
