//
//  CatCollectionViewCell.swift
//  Catsgram
//
//  Created by Yigit Serin on 30.07.2020.
//  Copyright © 2020 Yigit Serin. All rights reserved.
//

import UIKit

protocol CatCollectionViewCellListener {
    func saveTapped(index: Int?, model: CatModel?)
}

class CatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var index: Int?
    var catModel: CatModel?
    var listener: CatCollectionViewCellListener?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteTapped)))
        imageView.isUserInteractionEnabled = true
        
        //Try to show gif as a loading indicator.
        if let loaderData = LoadingManager.shared.loaderData{
            imageView.kf.indicatorType = .image(imageData: loaderData)
        }
    }
    
    func setCell(index: Int, catModel: CatModel, listener: CatCollectionViewCellListener?){
        
        self.index = index
        self.catModel = catModel
        self.listener = listener
        
        //Set cat image
        setCatImage(catModel: catModel)
        
        //Set favorite button
        setFavoriteButton(catModel: catModel)
    }

    private func setCatImage(catModel: CatModel){
        let imageUrl = URL(string: catModel.url)
        imageView.kf.setImage(with: imageUrl)
    }
    
    private func setFavoriteButton(catModel: CatModel){
        let isFavorite = catModel.isFavorite ?? false
        
        if isFavorite{
            favoriteImageView.image = UIImage(named: "FavoriteOn")
        }else{
            favoriteImageView.image = UIImage(named: "FavoriteOff")
        }
    }
    
    @objc func favoriteTapped(){
        listener?.saveTapped(index: index, model: catModel)
    }
}
