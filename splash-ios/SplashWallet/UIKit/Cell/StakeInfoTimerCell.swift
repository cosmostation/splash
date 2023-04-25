//
//  StakeInfoTimerCell.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/19.
//

import UIKit

class StakeInfoTimerCell: UITableViewCell {

    @IBOutlet weak var epochTitle: UILabel!
    @IBOutlet weak var timerTitle: UILabel!
    @IBOutlet weak var epochLabel: UILabel!
    @IBOutlet weak var timmerLabel: UILabel!
    
    var timer: Timer?
    var epoch: Int64?
    var epochStartTimestampMs: Int64?
    var epochDurationMs: Int64?
    
    var actionRefresh: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        epochTitle.text = NSLocalizedString("current_epoch", comment: "")
        timerTitle.text = NSLocalizedString("reward_distibution", comment: "")
    }
    
    override func prepareForReuse() {
        timer?.invalidate()
    }
    
    func onBindView() {
        epochLabel.text = "#" + (DataManager.shared.suiSystem?["epoch"].stringValue ?? "")
        epochStartTimestampMs = DataManager.shared.suiSystem?["epochStartTimestampMs"].int64Value
        epochDurationMs = DataManager.shared.suiSystem?["epochDurationMs"].int64Value
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onUpdateTime), userInfo: nil, repeats: true)
    }
    
    @objc func onUpdateTime() {
        let endEpoch = epochStartTimestampMs! + epochDurationMs!
        let current = Date().millisecondsSince1970
        if (endEpoch > current) {
            let gap = (endEpoch - current) / 1000
            var hours = String(gap / (60 * 60))
            var minutes = String((gap / 60) % 60)
            var second = String(gap % 60)
            if (hours.count == 1) { hours = "0" + hours }
            if (minutes.count == 1) { minutes = "0" + minutes }
            if (second.count == 1) { second = "0" + second }
            timmerLabel.text = hours + " : " + minutes + " : " + second
            
        } else {
            timer?.invalidate()
            actionRefresh?()
        }
    }
}
