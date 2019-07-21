//
//  PurchasesViewModel.swift
//  Dostawemo
//
//  Created by fnm8 on 21/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

class PurchasesViewModel {
    
    private let disposeBag = DisposeBag()
    let purchases = BehaviorRelay<[SectionPurchases]>(value: [])
    init(
        segment: Driver<Int>
    ){
        cPurchase(segment: segment)
        userPurchase(segment: segment)
    }
    
    private func cPurchase(segment: Driver<Int>){
        let realm = try! Realm()
        let purchasesObj = realm.objects(Purchases.self)
        let pObservable = Observable.array(from: purchasesObj)
        
        segment
            .filter{$0 != 2}
            .asObservable()
            .do(onNext: {[weak self] _ in self?.purchases.accept([])})
            .withLatestFrom(pObservable) {index, purchases -> [Purchases] in
                return purchases.filter{
                    switch index {
                    case 0:     return $0.collectedAmount >= $0.requiredAmount
                    case 1:     return true
                    default:    return false
                    }
                }
            }
            .map{
                return $0.map{SectionPurchases(header: "", items: [$0])}
            }
            .subscribe(onNext:{[weak self] p in self?.purchases.accept(p) })
            .disposed(by: disposeBag)
    }
    
    private func userPurchase(segment: Driver<Int>){
        let realm = try! Realm()
        let ordersObj = realm.objects(Order.self)
        let oObservable = Observable.array(from: ordersObj)
        
        segment
            .filter{$0 == 2}
            .asObservable()
            .do(onNext: {[weak self] _ in self?.purchases.accept([])})
            .withLatestFrom(oObservable) {_, orders -> [String] in
                return orders.map{ $0.purchaseId } }
            .map{ordersId -> [Purchases] in
                let uniqueOrderId = ordersId.removingDuplicates()
                let realm = try! Realm()
                let ordersObj = realm.objects(Purchases.self).filter("id IN %@", uniqueOrderId)
                return Array(ordersObj)
            }
            .map{
                return $0.map{SectionPurchases(header: "", items: [$0])}
            }
            .subscribe(onNext: {[weak self] p in self?.purchases.accept(p) })
            .disposed(by: disposeBag)
    }
}
