//
//  SelectChainCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/02/27.
//

import UIKit

class SelectChainCell: UITableViewCell {
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var checkedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.checkedImg.isHidden = true
        self.rootView.backgroundColor = .base01
    }
    
    func onBindChain(_ currentChain: ChainConfig?, _ supportChain: ChainConfig?) {
        nameLabel.text = supportChain?.chainDpName
        nameLabel.textColor = .base05
        if (currentChain?.chainName == supportChain?.chainName) {
            rootView.backgroundColor = .base02
            urlLabel.text = supportChain?.rpcEndPoint
            checkedImg.isHidden = false
        } else {
            rootView.backgroundColor = .base01
            urlLabel.text = supportChain?.rpcEndPoint
            checkedImg.isHidden = true
        }
    }
    
}
