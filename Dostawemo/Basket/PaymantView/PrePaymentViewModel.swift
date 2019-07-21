//
//  PrePaymentViewModel.swift
//  Dostawemo
//
//  Created by fnm8 on 20/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RealmSwift


class PrePaymentViewModel {
    
    
    func removeCartItem(by orderId: String){
        do {
            let realm = try Realm()
            let cartItem = realm.objects(CartItem.self)
                .filter(NSPredicate(format: "orderId = %@", orderId))
                .first
            if cartItem == nil { return }
            
            try realm.write {
                realm.delete(cartItem!)
            }
        } catch  {
            print("Error remove cart item by orderId: \(orderId)")
        }
    }
}
