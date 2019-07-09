//
//  DataLoader.swift
//  Dostawemo
//
//  Created by fnm8 on 21/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift
import RxCocoa
import RxSwift

class DataLoader {
    
    private let refreshTitleProduct = PublishSubject<()>()
    private let disposeBag = DisposeBag()
    
    private let productTableName = "products"
    private let purchaseTableName = "purchases"
    private let featuredFilter = true
    
    
    init(){
        refreshTitleProduct
            .subscribe(onNext: {[weak self] in self?.updateTitleProducts() })
            .disposed(by: disposeBag)
        
        updatePurchase()
        
        
        
        refreshTitleProduct.on(.next(()))
        
        
        
    }
    
    // MARK: - Load Purchase
    func updatePurchase(){
        let db = Firestore.firestore()
        db.collection(purchaseTableName).addSnapshotListener {[weak self] snap, error in
            if let err = error {
                print("Error updatePurchase: \(err)")
                return
            }
            var purchases: [Purchases] = []
            for document in snap!.documents {
                purchases.append(PurchasesSerialize.parse(id: document.documentID, data: document.data()))
            }
            self?.savePurchases(purchases)
        }
    }
    
    private func savePurchases(_ purchases: [Purchases]){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(purchases, update: .all)
            }
        } catch {
            print("Error save documents)")
            //refreshTitleProduct.on(.next(()))
            return
        }
    }
    
    // MARK: - Load title product
    func updateTitleProducts(){
        let db = Firestore.firestore()
        db.collection(productTableName).whereField("featured", isEqualTo: featuredFilter)
            .addSnapshotListener() { [weak self] (querySnapshot, err) in
                //print(querySnapshot)
                if let err = err {
                    print("Error getting documents: \(err)")
                    self?.refreshTitleProduct.on(.next(()))
                    return
                }
                var products: [Product] = []
                for document in querySnapshot!.documents {
                    products.append(ProductSerialize.create(data: document))
                }
                self?.saveProducts(products)
            }
    }
    
    private func saveProducts(_ products: [Product]){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(products, update: .all)
            }
        } catch {
            print("Error save documents)")
            refreshTitleProduct.on(.next(()))
            return
        }
    }
}
