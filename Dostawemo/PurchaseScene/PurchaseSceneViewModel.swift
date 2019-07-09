//
//  PurchaseSceneViewModel.swift
//  Dostawemo
//
//  Created by fnm8 on 25/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import RealmSwift

class PurchaseSceneViewModel {
    
    let purchase = BehaviorRelay<Purchases?>(value: nil)
    let products = BehaviorRelay<[Product]>(value: [])
    
    private let disposeBag = DisposeBag()
    private let productTableName = "products"
    
    init(purchaseId: String){
        configuratePurchase(id: purchaseId)
        configurateProducts(purchaseId: purchaseId)  
    }
    
    private func configuratePurchase(id: String){
        do {
            let realm = try Realm()
            let purchasesObj = realm.objects(Purchases.self)
                .filter(NSPredicate(format: "id = %@", id))
                .first
            
            Observable.from(optional: purchasesObj)
                .subscribe(onNext: {[weak self] obj in self?.purchase.accept(purchasesObj) })
                .disposed(by: disposeBag)
            
        } catch  {
            print("Error get purchase by id")
        }
    }
    
    private func configurateProducts(purchaseId: String){
        let db = Firestore.firestore()
        let observable = db.collection(productTableName)
            .whereField("purchaseId", isEqualTo: purchaseId)
            
        observable
            .addSnapshotListener() { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting products by purchase id: \(err)")
                    return
                }
                var products: [Product] = []
                for document in querySnapshot!.documents {
                    products.append(ProductSerialize.create(data: document))
                }
                self?.products.accept(products)
        }
    }
}
