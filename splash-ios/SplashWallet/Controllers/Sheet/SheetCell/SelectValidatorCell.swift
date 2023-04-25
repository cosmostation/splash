//
//  SelectValidatorCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/20.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class SelectValidatorCell: UITableViewCell {
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commissionTitle: UILabel!
    @IBOutlet weak var commissionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        commissionTitle.text = NSLocalizedString("commission", comment: "")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = UIImage(named: "validator_default")
    }
    
    func onBindValidator(_ indexPath: IndexPath) {
        let validator = DataManager.shared.suiActiveValidators[indexPath.row]
        if let url = validator.validatorUrl() {
            imgView.af.setImage(withURL: url)
        } else {
            imgView.image = UIImage(named: "validator_default")
        }
        nameLabel.text = validator["name"].stringValue
        commissionLabel.text = DecimalUtils.toString(validator["commissionRate"].stringValue, 2, 2)! + "%"
    }
    
}
