//
//  Order.swift
//  Dostawemo
//
//  Created by fnm8 on 01/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class BasketItem: Object {
    dynamic var productId: String = ""
    dynamic var productName: String = ""
    dynamic var purnaseId: String = ""
    dynamic var purchaseName: String = ""
    dynamic var price: Int = 0
    dynamic var size: String = ""
    dynamic var color: String = ""
    dynamic var amount: Int = 0
    
    
    
    var orderProductItem: [String: Any]{
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
