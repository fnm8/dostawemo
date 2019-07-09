//
//  BasketSectionItems.swift
//  Dostawemo
//
//  Created by fnm8 on 03/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation

class BasketSectionItems {
    var purnaseId: String
    var purchaseName: String
    var items: [BasketItem] = []
    
    var totalPrice: Double {
        var total: Int = 0
        items.forEach{
            let t = $0.amount * $0.price
            total += t
        }
        return Double(total)
    }
    
    init(purnaseId: String, purchaseName: String){
        self.purnaseId = purnaseId
        self.purchaseName = purchaseName
    }
    
}
