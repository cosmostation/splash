//
//  NftDetailVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/08.
//

import UIKit
import SwiftyJSON

class NftDetailVC: BaseVC {
    
    @IBOutlet weak var objectIdTitle: UILabel!
    @IBOutlet weak var typeTitle: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    
    @IBOutlet weak var nftImgView: UIImageView!
    @IBOutlet weak var nftNameLabel: UILabel!
    @IBOutlet weak var nftObjectIdLabel: UILabel!
    @IBOutlet weak var nftTypeLabel: UILabel!
    @IBOutlet weak var nftDescriptionLabel: UILabel!
    @IBOutlet weak var sendNftBtn: BaseButton!
    
    var suiNFT: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
        
        if let suiNFT = suiNFT {
            print("suiNFT ", suiNFT)
            if let url = suiNFT.nftULR() {
                nftImgView.af.setImage(withURL: url)
            } else {
                nftImgView.image = UIImage(named: "nft_default")
            }
            
            let name = suiNFT["content"]["fields"]["name"].stringValue
            let objectId = suiNFT["objectId"].stringValue
            let type = suiNFT["type"].stringValue.components(separatedBy: "::").last!
            let description = suiNFT["content"]["fields"]["description"].stringValue
            nftNameLabel.text = name
            nftObjectIdLabel.text = objectId
            nftTypeLabel.text = type
            nftDescriptionLabel.text = description
        }
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_nft_detail", comment: "")
        objectIdTitle.text = NSLocalizedString("object_id", comment: "")
        typeTitle.text = NSLocalizedString("type", comment: "")
        descriptionTitle.text = NSLocalizedString("description", comment: "")
        sendNftBtn.setTitle(NSLocalizedString("send_nft", comment: ""), for: .normal)
    }

    @IBAction func onClickLink(_ sender: UIButton) {
    }
    
    @IBAction func onClickSend(_ sender: UIButton) {
        if (!checkEnoughFee(cChainConfig, .TxSend)) {
            onShowToast(NSLocalizedString("error_not_enough_gas_fee", comment: ""))
            return
        }
        let sendNftVC = SendNftVC(nibName: "SendNftVC", bundle: nil)
        sendNftVC.suiNFT = suiNFT
        self.navigationController?.pushViewController(sendNftVC, animated: true)
    }
}

extension JSON {
    
    public func nftULR() -> URL? {
        if var urlString = rawNftUrlString() {
            if urlString.starts(with: "ipfs://") {
                urlString = urlString.replacingOccurrences(of: "ipfs://", with: "https://ipfs.io/ipfs/")
            }
            return URL(string: urlString)
        }
        return nil
    }
    
    public func rawNftUrlString() -> String? {
        if let url = self["content"]["fields"]["url"].string {
            return url
        }
        if let url = self["content"]["fields"]["img_url"].string {
            return url
        }
        return nil
    }
    
    
    public func validatorUrl() -> URL? {
        if let url = self["imageUrl"].string {
            return URL(string: url)
        }
        return nil
    }
}
