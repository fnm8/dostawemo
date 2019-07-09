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
                    let purchase = PurchasesSerialize.parse(id: document.documentID, data: document.data()!)
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
            let basketItem = BasketItem()
            basketItem.productId = product.id
            basketItem.productName = product.name
            basketItem.purnaseId = purchase.id
            basketItem.purchaseName = purchase.name
            basketItem.amount = options.count
            basketItem.price = product.price
            basketItem.color = options.color
            basketItem.size = options.size
            
            try realm.write {
                realm.add(basketItem)
            }
            successAddToBusket.onNext(())
        } catch {
            print("Error save to db")
        }
    }
    
    private func getPurchase(by id: String) -> Observable<Result<Purchases>>{
        
        return Observable.create { observer in
            
            
            return Disposables.create()
        }
        
    }
}
