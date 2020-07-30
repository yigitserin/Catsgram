//
//  CatModel.swift
//  Catsgram
//
//  Created by Yigit Serin on 28.07.2020.
//  Copyright © 2020 Yigit Serin. All rights reserved.
//

import Foundation

struct CatModel: Codable {
    var id: String
    var url: String
    var width: Int
    var height: Int
    var addedDate: Date? = Date()
    var isFavorite: Bool? = false
}
