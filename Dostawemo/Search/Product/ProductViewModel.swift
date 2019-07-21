//
//  ProductViewModel.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 07/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import Firebase

class ProductViewModel {
    
    private let disposeBag = DisposeBag()
    
    let successAddToBusket = PublishSubject<()>()
    let errorAddToBusket = PublishSubject<()>()
    
    var product: Product
    var options: ProductOptions = ProductOptions()
    
    init(product: Product){
        self.product = product
    }
    
    
    func addToBusket(){
        let purchaseTableName = "purchases"
        let db = Firestore.firestore()
        db.collection(purchaseTableName).document(product.purchaseId)
            .getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    let purchase = PurchasesSerialize.create(id: document.documentID, data: document.data()!)
                    self?.saveBasketItem(purchase: purchase)
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
        }
    }
    
    private func saveBasketItem(purchase: Purchases){
        do {
            let realm = try Realm()
            let cartItemsObj = realm.objects(CartItem.self)
                .filter(NSPredicate(format: "purnaseId = %@", purchase.id))
                .first
            
            if cartItemsObj != nil {
                let productItem = cartItemsObj!.products
                    .first(where: {[weak self] item in
                        item.productId == self!.product.id
                            && item.color == options.color
                            && item.size == options.size
                    })
                
                if productItem != nil {
                    
                    try realm.write {
                        let amount = productItem!.amount + options.count
                        productItem!.amount = amount
                    }
                    
                } else {
                    
                    let productItem = ProductCartItem()
                    productItem.productId = product.id
                    productItem.productName = product.name
                    productItem.productImage = product.imagesPath.first ?? ""
                    productItem.price = product.price
                    productItem.color = options.color
                    productItem.size = options.size
                    productItem.amount = options.count
                    
                    try realm.write {
                        cartItemsObj!.products.append(productItem)
                    }
                    
                }
            } else {
                
                let cartItem = CartItem()
                cartItem.purnaseId = purchase.id
                cartItem.purchaseName = purchase.name
                cartItem.purnaseImage = purchase.image
                
                let productItem = ProductCartItem()
                productItem.productId = product.id
                productItem.productName = product.name
                productItem.productImage = product.imagesPath.first ?? ""
                productItem.price = product.price
                productItem.color = options.color
                productItem.size = options.size
                productItem.amount = options.count
                
                cartItem.products.append(productItem)
                
                try realm.write {
                    realm.add(cartItem)
                }
            }
            successAddToBusket.onNext(())
        } catch {
            print("Error save to db")
        }
    }
    
}
