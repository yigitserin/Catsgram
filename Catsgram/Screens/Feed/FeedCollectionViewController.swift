//
//  FeedCollectionViewController.swift
//  Catsgram
//
//  Created by Yigit Serin on 29.07.2020.
//  Copyright © 2020 Yigit Serin. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCollectionViewController: CatsListViewController {
        
    let networkManager = NetworkManager()
    
    var page: Int = 0
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMoreCats()
        updateTabBarBadge()
    }
    
    private func requestMoreCats(){
        self.isLoading = true
        
        networkManager.requestCats(page: page, onSuccess: { cats in
            self.isLoading = false
            self.page += 1
            self.saveCatsToCoreData(cats: cats)
        }, onError: { error in
            self.isLoading = false
            self.showErrorDialog(error: "Could not load more kitties at this time, please try again later.")
        })
    }
    
    private func saveCatsToCoreData(cats: [CatModel]){
        let saveCatResponse = CatsManager.shared.addCats(cats: cats)
        
        if saveCatResponse{
            self.cats.append(contentsOf: cats)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }else{
            self.showErrorDialog(error: "Could not save kitties at this time, please try again later.")
        }
    }
}

extension FeedCollectionViewController{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.cats.count - 2 && !isLoading {
            requestMoreCats()
        }
    }
}
