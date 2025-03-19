//
//  InfoPopUpSheet.swift
//  SplashWallet
//
//  Created by 차소민 on 3/13/25.
//

import UIKit
import SafariServices

class InfoPopUpSheet: BaseVC {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var actionBtn: BaseButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    var viewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.layer.cornerRadius = 8
        
        titleLabel.text = NSLocalizedString("title_migration_app", comment: "")
        infoLabel.text = NSLocalizedString("msg_migration_app", comment: "")
        
        let attributeString = NSMutableAttributedString(string: infoLabel.text!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        attributeString.addAttributes([.paragraphStyle: style,
                                       .font: UIFont(name: "Pretendard-SemiBold", size: 14)!,
                                       .foregroundColor: UIColor.text01],
                                      range: NSRange(location: 0, length: attributeString.length))

        
        infoLabel.attributedText = attributeString


        
        var attributedTitle = AttributedString(NSLocalizedString("download_app", comment: ""))
        attributedTitle.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        actionBtn.configuration?.attributedTitle = attributedTitle
        actionBtn.configuration?.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 0)
        
        var closeAttributedTitle = AttributedString(NSLocalizedString("cancel", comment: ""))
        closeAttributedTitle.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        closeBtn.configuration?.attributedTitle = closeAttributedTitle

        
    }
    @IBAction func onCloseAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onMoveAction(_ sender: Any) {
        dismiss(animated: false)
        guard let url = URL(string: "https://apps.apple.com/app/cosmostation/id1459830339") else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .popover
        viewController?.present(safariViewController, animated: true, completion: nil)
    }
}
