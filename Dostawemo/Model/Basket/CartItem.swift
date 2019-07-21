//
//  CartItem.swift
//  Dostawemo
//
//  Created by fnm8 on 11/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class CartItem: Object {
    dynamic var orderId: String = ""
    dynamic var purnaseId: String = ""
    dynamic var purchaseName: String = ""
    dynamic var purnaseImage: String = ""
    dynamic var products = List<ProductCartItem>()
    
    var totalPrice: Double {
        var total: Double = 0
        products.forEach{
            let t = Double($0.amount) * $0.price
            total += t
        }
        return total
    }
    
}

@objcMembers
class ProductCartItem: Object {
    dynamic var productId: String = ""
    dynamic var productName: String = ""
    dynamic var productImage: String = ""
    dynamic var price: Double = 0
    dynamic var size: String = ""
    dynamic var color: String = ""
    dynamic var amount: Int = 0
    
    var productJson: [String: Any]{
        return [
            "productId": productId,
            "productName": productName,
            "options": [
                "color": color,
                "size": size
            ],
            "price": price,
            "count": amount
        ]
    }
    
}
