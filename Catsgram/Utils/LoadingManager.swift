//
//  LoadingManager.swift
//  Catsgram
//
//  Created by Yigit Serin on 30.07.2020.
//  Copyright © 2020 Yigit Serin. All rights reserved.
//

import Foundation
import Kingfisher

class LoadingManager{
    static let shared = LoadingManager()
    
    public var loaderData: Data?
    
    private init(){
        if let path = Bundle.main.url(forResource: "LoadingImage", withExtension: "gif"){
            do{
                loaderData = try Data(contentsOf: path)
            }catch{
                
            }
        }
    }
}
