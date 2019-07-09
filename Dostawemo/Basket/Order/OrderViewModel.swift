//
//  OrderViewModel.swift
//  Dostawemo
//
//  Created by fnm8 on 09/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class OrderViewModel {
    
    private let disposeBag = DisposeBag()
    
    var basketSection = BehaviorRelay<BasketSectionItems?>(value: nil)
    
    init(purchaseId: String){
        cBasketItem(purchaseId: purchaseId)
    }
    
    private func cBasketItem(purchaseId: String){
        do {
            let realm = try Realm()
            let basketItemsObj = realm.objects(BasketItem.self)
                .filter(NSPredicate(format: "purnaseId = %@", purchaseId))
            
             Observable.array(from: basketItemsObj)
                .subscribe(onNext: {[weak self] obj in
                    if obj.isEmpty { return }
                    let section = BasketSectionItems(
                        purnaseId: obj.first!.purnaseId,
                        purchaseName: obj.first!.purchaseName
                    )
                    section.items = obj
                    self?.basketSection.accept(section)
                }).disposed(by: disposeBag)
            
        } catch  {
            print("Error get purchase by id")
        }
    }
}
