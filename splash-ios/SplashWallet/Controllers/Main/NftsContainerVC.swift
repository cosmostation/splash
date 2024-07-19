//
//  NftsContainerVC.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/04/09.
//

import UIKit
import SwiftyJSON
import AlamofireImage
import Kingfisher

class NftsContainerVC: BaseVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    var mainTabVC: MainTab!
    var refresher: UIRefreshControl!
    var suiNFTs = Array<JSON>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(onRequestFetch), for: .valueChanged)
        refresher.tintColor = .base05
        collectionView.addSubview(refresher)
        collectionView.alwaysBounceVertical = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAccountReady), name: Notification.Name("AccountReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDataFetched), name: Notification.Name("DataFetched"), object: nil)
        mainTabVC = ((self.parent)?.parent)?.parent as? MainTab
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AccountReady"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DataFetched"), object: nil)
        refresher.endRefreshing()
    }
    
    @objc func onRequestFetch() {
        mainTabVC.updateState(false)
    }
    
    @objc func onAccountReady() {
        refresher.endRefreshing()
        suiNFTs.removeAll()
        cAccount = DataManager.shared.account
        cChainConfig = cAccount.chainConfig
    }
    
    @objc func onDataFetched() {
        suiNFTs.removeAll()
        DataManager.shared.suiObjects.forEach { object in
            if (object["display"]["data"].description != "null") {
                suiNFTs.append(object)
            }
        }
        if (suiNFTs.count > 0) {
            collectionView.reloadData()
            emptyView.isHidden = true
        } else {
            emptyView.isHidden = false
        }
    }

}

extension NftsContainerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suiNFTs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"NftCell", for: indexPath) as? NftCell {
            let suiNFT = suiNFTs[indexPath.row]
            if let url = suiNFT.nftULR() {
                cell.imageView.kf.setImage(with: url)
            } else {
                cell.imageView.image = UIImage(named: "nft_default")
            }

            let name = suiNFT["display"]["data"]["name"].stringValue
            let id = suiNFT["objectId"].stringValue
            if (!name.isEmpty) {
                cell.titleLabel.text = name
            } else if (!id.isEmpty) {
                cell.titleLabel.text = id
            } else {
                cell.titleLabel.text = ""
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: 203)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nftDetailVC = NftDetailVC(nibName: "NftDetailVC", bundle: nil)
        nftDetailVC.suiNFT = suiNFTs[indexPath.row]
        nftDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nftDetailVC, animated: true)
    }
}

class NftCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
