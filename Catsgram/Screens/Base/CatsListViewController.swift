//
//  CatsListViewController.swift
//  Catsgram
//
//  Created by Yigit Serin on 30.07.2020.
//  Copyright © 2020 Yigit Serin. All rights reserved.
//

import UIKit

class CatsListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cats: [CatModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCollectionView()
    }
    
    func updateTabBarBadge(){
        if let favoriteCount = CatsManager.shared.getCats(favoriteCats: true)?.count, let tabBarItems = tabBarController?.tabBar.items, tabBarItems.indices.contains(1){
            
            if favoriteCount > 0{
                tabBarItems[1].badgeValue = String(favoriteCount)
            }else{
                tabBarItems[1].badgeValue = nil
            }
        }
    }
    
    func showErrorDialog(error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let button = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CatsListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func initializeCollectionView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "CatCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CatCollectionViewCell")
        self.collectionView.allowsSelection = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageWidth = CGFloat(cats[indexPath.row].width)
        let imageHeight = CGFloat(cats[indexPath.row].height)
        let itemHeight = collectionView.frame.width * imageHeight / imageWidth
        let itemSize = CGSize(width: collectionView.frame.width, height: itemHeight)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionViewCell", for: indexPath) as! CatCollectionViewCell
        
        cell.setCell(index: indexPath.row, catModel: cats[indexPath.row], listener: self)
        
        return cell
    }
}

extension CatsListViewController: CatCollectionViewCellListener{
    func saveTapped(index: Int?, model: CatModel?) {
        guard let index = index, let model = model else { return }
        
        let isFavorite = model.isFavorite ?? false
        
        let favoriteSuccess = CatsManager.shared.favoriteCat(id: model.id, isFavorite: !isFavorite)
        if favoriteSuccess{
            self.cats[index].isFavorite = !isFavorite
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
        
        updateTabBarBadge()
    }
}
