//
//  MainTabDapps.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/01/07.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MainTabDapps: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    var dapps:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        
        AF.request("https://raw.githubusercontent.com/cosmostation/splash/main/resources/dapp.json",
                   method: .get).response { response in
            switch response.result {
            case .success(let value):
                if let value = value, let response = try? JSONDecoder().decode(JSON.self, from: value) {
                    self.dapps = response.arrayValue
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension MainTabDapps: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dapps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:"DappCell") as? DappCell {
            let item = dapps[indexPath.row]
            if let url = URL(string: item["icon"].stringValue) {
                cell.iconImg.af.setImage(withURL: url)
                cell.iconImg.layer.cornerRadius = 10
                cell.iconImg.layer.masksToBounds = true
            }
            cell.titleLabel.text = item["name"].stringValue
            cell.msgLabel.text = item["description"].stringValue
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dapps[indexPath.row]
        let link = item["link"].stringValue
        let dappVC = DappVC(nibName: "DappVC", bundle: nil)
        dappVC.dappURL = link
        dappVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(dappVC, animated: true)
    }
}

class DappCell: UITableViewCell {
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
}
