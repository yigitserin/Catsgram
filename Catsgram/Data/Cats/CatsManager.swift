//
//  CatsManager.swift
//  Catsgram
//
//  Created by Yigit Serin on 28.07.2020.
//  Copyright © 2020 Yigit Serin. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CatsManager{
    
    static let shared = CatsManager()
    
    var persistentContainer: NSPersistentContainer?
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.persistentContainer = appDelegate.persistentContainer
        appDelegate.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func addCats(cats: [CatModel]) -> Bool{
        guard let container = persistentContainer else { return false }
        
        for catModel in cats{
            if let entity = NSEntityDescription.entity(forEntityName: "Cat", in: container.viewContext){
                let cat = NSManagedObject(entity: entity, insertInto: container.viewContext)
                cat.setValue(catModel.id, forKey: "id")
                cat.setValue(catModel.url, forKey: "url")
                cat.setValue(catModel.width, forKey: "width")
                cat.setValue(catModel.height, forKey: "height")
                cat.setValue(Date(), forKey: "addedDate")
                cat.setValue(catModel.isFavorite, forKey: "isFavorite")
            }
        }
        
        do{
            try container.viewContext.save()
            return true
        }catch{
            return false
        }
    }
    
    func getCats(favoriteCats: Bool) -> [CatModel]?{
        guard let container = persistentContainer else { return nil }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cat")
        
        if favoriteCats{
            fetchRequest.predicate = NSPredicate(format: "isFavorite = %d", true)
        }
        
        do{
            let results = try container.viewContext.fetch(fetchRequest)
            var catModels: [CatModel] = []
            if let resultObjects = results as? [NSManagedObject]{
                for resultObject in resultObjects{
                    if
                        let id = resultObject.value(forKey: "id") as? String,
                        let url = resultObject.value(forKey: "url") as? String,
                        let width = resultObject.value(forKey: "width") as? Int,
                        let height = resultObject.value(forKey: "height") as? Int,
                        let addedDate = resultObject.value(forKey: "addedDate") as? Date,
                        let isFavorite = resultObject.value(forKey: "isFavorite") as? Bool
                    {
                        catModels.append(CatModel(id: id, url: url, width: width, height: height, addedDate: addedDate, isFavorite: isFavorite))
                    }
                }
                return catModels
            }else{
                return nil
            }
        }catch{
            return nil
        }
    }
    
    func favoriteCat(id: String, isFavorite: Bool) -> Bool{
        
        guard let container = persistentContainer else { return false }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cat")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do{
            let results = try container.viewContext.fetch(fetchRequest)
            if let resultObjects = results as? [NSManagedObject]{
                for resultObject in resultObjects{
                    resultObject.setValue(isFavorite, forKey: "isFavorite")
                }
            }
        }catch{
            return false
        }
        
        do{
            try container.viewContext.save()
            return true
        }catch{
            return false
        }
    }
    
    func removeCats() -> Bool{
        guard let container = persistentContainer else { return false }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Cat")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(deleteRequest)
            return true
        } catch {
            return false
        }
    }
}
