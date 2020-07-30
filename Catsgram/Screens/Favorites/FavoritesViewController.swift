//
//  FavoritesViewController.swift
//  Catsgram
//
//  Created by Yigit Serin on 30.07.2020.
//  Copyright © 2020 Yigit Serin. All rights reserved.
//

import UIKit

class FavoritesViewController: CatsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getSortedCatsFromCoreData()
        self.collectionView.reloadData()
    }
    
    private func getSortedCatsFromCoreData(){
        if let cats = CatsManager.shared.getCats(favoriteCats: true){
            let sortedCats = cats.sorted { (cat1, cat2) -> Bool in
                return cat1.addedDate ?? Date() < cat2.addedDate ?? Date()
            }
            self.cats = sortedCats
        }
    }
}
