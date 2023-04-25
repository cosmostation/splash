//
//  ReceiveVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/03/02.
//

import UIKit
import QRCode

class ReceiveVC: BaseVC {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qrCodeImgView: UIImageView!
    @IBOutlet weak var addressCardView: CardView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shareBtn: BaseButton!
    
    var account: BaseAccount!
    var address: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        account = DataManager.shared.account
        address = account.baseAddress?.address
        let qrCode = QRCode(string: address, size: CGSize(width: 500, height: 500))
        
        nameLabel.text = account.name
        addressLabel.text = address
        qrCodeImgView.image = try? qrCode?.image()
        
        addressCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickCopy)))
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_receive", comment: "")
    }
    
    
    @objc func onClickCopy() {
        UIPasteboard.general.string = address.trimmingCharacters(in: .whitespacesAndNewlines)
        onShowToast(NSLocalizedString("address_copied", comment: ""))
    }
    
    @IBAction func onClickShare(_ sender: UIButton) {
        let shareVC = UIActivityViewController(activityItems: [address], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }
}
