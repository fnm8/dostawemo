//
//  Product.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 05/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import Firebase


class Product {
    
    var id: String
    var price: Int?
    var name: String
    var marketPrice: Int?
    var primeCost: String  // ??
    var colors: [String] = []
    var featured: Int   // ??
    var video: String
    var imagesPath: [String] = []
    var sizes: [String] = []
    var composition: String // ??
    var desc: String
    
    
    var imagesHash: [String: UIImage] = [:]
    
    init(data: QueryDocumentSnapshot) {
        self.id = data.documentID
        let json = data.data()
        self.price = json["price"] as? Int
        self.name = json["name"] as? String ?? ""
        self.marketPrice = json["marketPrice"] as? Int
        self.primeCost = json["primeCost"] as? String ?? ""
        self.colors = json["colors"] as? [String] ?? []
        self.featured = json["featured"] as? Int ?? 0
        self.video = json["video"] as? String ?? ""
        self.imagesPath = json["images"] as? [String] ?? []
        self.composition = json["composition"] as? String ?? ""
        self.desc = json["desc"] as? String ?? ""
        self.sizes = json["sizes"] as? [String] ?? []
    }
}
