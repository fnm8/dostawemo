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

class TopProductsViewModel {
    
    let products = BehaviorRelay<[Product]>(value: [])
    
    private let featuredFilter = true
    
    init() {
        observeProducts()
    }
    
    private func observeProducts(){
        let db = Firestore.firestore()
        db.collection("products")
            .whereField("featured", isEqualTo: featuredFilter)
            .getDocuments() { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                }
                var products: [Product] = []
                for document in querySnapshot!.documents {
                    products.append(Product(data: document))
                }
                self?.products.accept(products)
            }
    }
    
}
