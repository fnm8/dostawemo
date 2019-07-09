//
//  TopProductsViewModel.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 05/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Firebase
import RealmSwift
import Realm
import RxRealm

class TopProductsViewModel {
    
    let disposeBag = DisposeBag()
    let products = BehaviorRelay<[Product]>(value: [])
    
    private let featuredFilter = true
    
    init() {
        //observeProducts()
        let realm = try! Realm()
        let products = realm.objects(Product.self)
        
        Observable.array(from: products)
            .subscribe(onNext: { [weak self] p in self?.products.accept(p) })
            .disposed(by: disposeBag)
    }
    
//    private func observeProducts(){
//        let db = Firestore.firestore()
//        db.collection("products")
//            .whereField("featured", isEqualTo: featuredFilter)
//            .getDocuments() { [weak self] (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                    return
//                }
//                var products: [Product] = []
//                for document in querySnapshot!.documents {
//                    products.append(ProductSerialize.create(data: document))
//                }
//                let realm = try! Realm()
//                try! realm.write {
//                    realm.add(products, update: .all)
//                }
//
//
//
//               // self?.products.accept(products)
//            }
//    }
    
}
