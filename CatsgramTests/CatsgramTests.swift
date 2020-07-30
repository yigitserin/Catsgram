//
//  CatsgramTests.swift
//  CatsgramTests
//
//  Created by Yigit Serin on 28.07.2020.
//  Copyright © 2020 Yigit Serin. All rights reserved.
//

import XCTest
@testable import Catsgram

class CatsgramTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let _ = CatsManager.shared.removeCats()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCatModelCoreDataOperations() throws{
        //testCatModelInit
        let catId = "catId"
        let catUrl = "catUrl"
        let catIsFavorite = false
        let catImageWidth = 100
        let catImageHeight = 200
        let addedDate = Date.distantFuture
        let catModel = getTestCatModel()
        
        XCTAssertEqual(catId, catModel.id)
        XCTAssertEqual(catUrl, catModel.url)
        XCTAssertEqual(catIsFavorite, catModel.isFavorite)
        XCTAssertEqual(catImageWidth, catModel.width)
        XCTAssertEqual(catImageHeight, catModel.height)
        XCTAssertEqual(addedDate, catModel.addedDate)
        
        //testCatModelAdd
        let addCatsResult = CatsManager.shared.addCats(cats: [catModel])
        XCTAssert(addCatsResult)
        
        //testCatModelGet
        let catGets = CatsManager.shared.getCats(favoriteCats: false)
        XCTAssertNotNil(catGets)
        XCTAssertEqual(catGets?.count, 1)
        
        //dont add duplicates to core data
        let _ = CatsManager.shared.addCats(cats: [catModel])
        let catGets2 = CatsManager.shared.getCats(favoriteCats: false)
        XCTAssertNotNil(catGets2)
        XCTAssertEqual(catGets2?.count, 1)
        
        //get favorites and check if count is 0
        let catsGetFavorites1 = CatsManager.shared.getCats(favoriteCats: true)
        XCTAssertEqual(catsGetFavorites1?.count, 0)
        
        //add favorites
        let catFav = CatsManager.shared.favoriteCat(id: catId, isFavorite: true)
        XCTAssert(catFav)
        
        //get favorites and check if count is 1
        let catsGetFavorites2 = CatsManager.shared.getCats(favoriteCats: true)
        XCTAssertEqual(catsGetFavorites2?.count, 1)
        
        //remove favorites
        let catRemoveFav = CatsManager.shared.favoriteCat(id: catId, isFavorite: false)
        XCTAssert(catRemoveFav)
        
        //get favorites and check if count is 0
        let catsGetFavorites3 = CatsManager.shared.getCats(favoriteCats: true)
        XCTAssertEqual(catsGetFavorites3?.count, 0)
        
        //remove all favorites
        let removeRequest = CatsManager.shared.removeCats()
        XCTAssert(removeRequest)
        
        //get all cats and check if count is 0
        let catGets3 = CatsManager.shared.getCats(favoriteCats: false)
        XCTAssertNotNil(catGets3)
        XCTAssertEqual(catGets3?.count, 0)
    }
    
    private func getTestCatModel () -> CatModel{
        let catId = "catId"
        let catUrl = "catUrl"
        let catIsFavorite = false
        let catImageWidth = 100
        let catImageHeight = 200
        let addedDate = Date.distantFuture
        let catModel = CatModel(id: catId, url: catUrl, width: catImageWidth, height: catImageHeight, addedDate: addedDate, isFavorite: catIsFavorite)
        return catModel
    }

    func testCatModelInit() throws {
        let catId = "catId"
        let catUrl = "catUrl"
        let catIsFavorite = false
        let catImageWidth = 100
        let catImageHeight = 200
        let addedDate = Date.distantFuture
        let catModel = getTestCatModel()
        
        XCTAssertEqual(catId, catModel.id)
        XCTAssertEqual(catUrl, catModel.url)
        XCTAssertEqual(catIsFavorite, catModel.isFavorite)
    }
    
    func testCatModelAdd() throws{
        let catModel = getTestCatModel()
        
        let addCatsResult = CatsManager.shared.addCats(cats: [catModel])
        XCTAssert(addCatsResult)
    }
    
    func testCatModelGet() throws{
        let catGets = CatsManager.shared.getCats(favoriteCats: false)
        XCTAssertNotNil(catGets)
    }
    
    func testCatModelFavoritesGet() throws{
        let catsGet = CatsManager.shared.getCats(favoriteCats: true)
        XCTAssertNotNil(catsGet)
    }
    
    func testCatModelAddFavorites() throws{
        let catId = "catId"
        let catIsFavorite = true
        
        let catFav = CatsManager.shared.favoriteCat(id: catId, isFavorite: catIsFavorite)
        XCTAssert(catFav)
    }
    
    func testCatModelRemoveFavorites() throws{
        let catId = "catId"
        let catIsFavorite = false
        
        let catFav = CatsManager.shared.favoriteCat(id: catId, isFavorite: catIsFavorite)
        XCTAssert(catFav)
    }
    
    func testCatModelRemoveAll() throws{
        let removeRequest = CatsManager.shared.removeCats()
        XCTAssert(removeRequest)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
