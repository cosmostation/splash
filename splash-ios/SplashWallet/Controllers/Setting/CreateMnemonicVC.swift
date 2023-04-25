//
//  CreateMnemonicVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/15.
//

import UIKit
import web3swift

class CreateMnemonicVC: BaseVC {
    
    @IBOutlet weak var nextBtn: BaseButton!
    
    
    @IBOutlet weak var warningMsgLabel: UILabel!
    @IBOutlet weak var mnemonicTitle: UILabel!
    @IBOutlet weak var wordSizeSegment: UISegmentedControl!
    
    @IBOutlet weak var wordCardView: CardView!
    @IBOutlet weak var word00: UILabel!
    @IBOutlet weak var word01: UILabel!
    @IBOutlet weak var word02: UILabel!
    @IBOutlet weak var word03: UILabel!
    @IBOutlet weak var word04: UILabel!
    @IBOutlet weak var word05: UILabel!
    @IBOutlet weak var word06: UILabel!
    @IBOutlet weak var word07: UILabel!
    @IBOutlet weak var word08: UILabel!
    @IBOutlet weak var word09: UILabel!
    @IBOutlet weak var word10: UILabel!
    @IBOutlet weak var word11: UILabel!
    @IBOutlet weak var word12: UILabel!
    @IBOutlet weak var word13: UILabel!
    @IBOutlet weak var word14: UILabel!
    @IBOutlet weak var word15: UILabel!
    @IBOutlet weak var word16: UILabel!
    @IBOutlet weak var word17: UILabel!
    @IBOutlet weak var word18: UILabel!
    @IBOutlet weak var word19: UILabel!
    @IBOutlet weak var word20: UILabel!
    @IBOutlet weak var word21: UILabel!
    @IBOutlet weak var word22: UILabel!
    @IBOutlet weak var word23: UILabel!
    
    @IBOutlet weak var stack04: UIStackView!
    @IBOutlet weak var stack05: UIStackView!
    @IBOutlet weak var stack06: UIStackView!
    @IBOutlet weak var stack07: UIStackView!
    
    var wordLabels: [UILabel] = [UILabel]()
    var accountName: String!
    var mnemonic: String!
    var bitsOfEntropy = 128

    override func viewDidLoad() {
        super.viewDidLoad()
        wordSizeSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.base04, NSAttributedString.Key.font: font6], for:.normal)
        wordSizeSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font6], for:.selected)
        
        wordLabels = [word00, word01, word02, word03, word04, word05, word06, word07, word08, word09, word10, word11,
                      word12, word13, word14, word15, word16, word17, word18, word19, word20, word21, word22, word23]
        
        
        onUpdateView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCopyMenmonics))
        tap.cancelsTouchesInView = false
        wordCardView.addGestureRecognizer(tap)
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_create_mnemonic", comment: "")
        warningMsgLabel.text = NSLocalizedString("mnemonic_wanning", comment: "")
        mnemonicTitle.text = NSLocalizedString("mnemonic_phrases", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
    }
    
    func onUpdateView() {
        mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)
        let words = mnemonic!.components(separatedBy: " ")
        for (index, word) in words.enumerated() {
            wordLabels[index].text = word
            wordLabels[index].adjustsFontSizeToFitWidth = true
        }
    }

    @IBAction func onSwitchSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            stack04.isHidden = true
            stack05.isHidden = true
            stack06.isHidden = true
            stack07.isHidden = true
            bitsOfEntropy = 128
            
        } else {
            stack04.isHidden = false
            stack05.isHidden = false
            stack06.isHidden = false
            stack07.isHidden = false
            bitsOfEntropy = 256
        }
        onUpdateView()
    }
    
    @IBAction func onClickNext(_ sender: UIButton) {
        onCreateAccount(accountName, mnemonic)
    }
    
    @objc func onCopyMenmonics() {
        UIPasteboard.general.string = mnemonic
        onShowToast(NSLocalizedString("mnemonic_copied", comment: ""))
    }
    
    func onCreateAccount(_ name: String, _ mnemonic: String) {
        onShowWait()
        DispatchQueue.global().async {
            let newAccount = BaseAccount.init(uuid: UUID().uuidString, name: name,
                                              withMenmonic: true, time: Date().millisecondsSince1970, favo: false, mnemonic: mnemonic)
            let result = BaseData.instance.insertAccount(newAccount)
            if let account = BaseData.instance.selectAccountById(result) {
                BaseData.instance.setMnemonic(account.uuid!, mnemonic)
                BaseData.instance.setRecentAccount(account.id!)
                DispatchQueue.main.async(execute: {
                    self.onDismissWait()
                    self.onStartMainTab()
                });
            }
        }
    }
}
