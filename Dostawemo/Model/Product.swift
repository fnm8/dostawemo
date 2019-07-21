//
//  Product.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 05/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift

@objcMembers
class Product: Object {
    
    dynamic var id: String = ""
    dynamic var price: Double = 0.0
    dynamic var name: String = ""
    dynamic var marketPrice: Double = 0.0
    dynamic var primeCost: String = ""
    dynamic var colors = List<String>()
    dynamic var featured: Int = 0
    dynamic var video: String = ""
    dynamic var imagesPath = List<String>()
    dynamic var sizes = List<String>()
    dynamic var composition: String = ""
    dynamic var desc: String = ""
    dynamic var purchaseId: String = ""
    dynamic var created: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class ProductSerialize {
    
    static func create(data: QueryDocumentSnapshot) -> Product{
        let product = Product()
        product.id = data.documentID
        let json = data.data()
        //print(json)
        
        product.price = json["price"] as? Double ?? 0.0
        product.name = json["name"] as? String ?? ""
        product.marketPrice = json["marketPrice"] as? Double ?? 0.0
        product.primeCost = json["primeCost"] as? String ?? ""
        let colors = json["colors"] as? [String] ?? []
        
        let colorsList = List<String>()
        colorsList.append(objectsIn: colors)
        product.colors = colorsList
        
        product.featured = json["featured"] as? Int ?? 0
        product.video = json["video"] as? String ?? ""
        
        let images = json["images"] as? [String] ?? []
        let imagesList = List<String>()
        imagesList.append(objectsIn: images)
        product.imagesPath = imagesList
        
        product.composition = json["composition"] as? String ?? ""
        product.desc = json["desc"] as? String ?? ""
        
        let sizes = json["sizes"] as? [String] ?? []
        let sizesList = List<String>()
        sizesList.append(objectsIn: sizes)
        product.sizes = sizesList
        
        if let timestamp = json["created"] as? Timestamp{
            product.created = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        }
        
        product.purchaseId = json["purchaseId"] as? String ?? ""
        return product
    }
}
