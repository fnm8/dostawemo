//
//  UserPurchaseViewModel.swift
//  Dostawemo
//
//  Created by fnm8 on 21/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift

class UserPurchaseViewModel {
    
    let purchase = BehaviorRelay<Purchases?>(value: nil)
    let orders = BehaviorRelay<[Order]>(value: [])
    
    init(purchaseId: String){
        let realm = try! Realm()
        let pObj = realm.objects(Purchases.self).filter("id = %@", purchaseId).first
        purchase.accept(pObj)
        
        if pObj != nil{
            let ordersObj = realm.objects(Order.self).filter("purchaseId = %@", purchaseId)
            orders.accept(Array(ordersObj))
        }
    }
}
