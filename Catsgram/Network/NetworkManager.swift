//
//  NetworkManager.swift
//  Catsgram
//
//  Created by Yigit Serin on 29.07.2020.
//  Copyright © 2020 Yigit Serin. All rights reserved.
//

import Foundation

class NetworkManager{
    
    let decoder = JSONDecoder()
    
    let CATAPI_HEADER = "x-api-key"
    let CATAPI_KEY = "735ea6ac-dd4e-4886-9092-43fc1251be94"
    
    public func requestCats(page: Int, onSuccess: @escaping ([CatModel]) -> (), onError: @escaping (String) -> ()){
        let urlPath = "https://api.thecatapi.com/v1/images/search?limit=100"
        guard let url = URL(string: urlPath) else { return }
        var request = URLRequest(url: url)
        request.setValue(CATAPI_KEY, forHTTPHeaderField: CATAPI_HEADER)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                //Error
                onError(error.localizedDescription)
            }else{
                if let data = data{
                    do{
                        let cats = try self.decoder.decode(Array<CatModel>.self, from: data)
                        onSuccess(cats)
                    }catch{
                        onError("Error parsing response.")
                    }
                }else{
                    onError("Error parsing response.")
                }
            }
        }
        task.resume()
    }
}
