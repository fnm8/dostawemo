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
    let purchases = BehaviorRelay<[Purchases]>(value: [])
    init(
        segment: Driver<Int>
    ){
        
        let realm = try! Realm()
        let purchasesObj = realm.objects(Purchases.self)
        
        let pObservable = Observable.array(from: purchasesObj)
            
        segment.asObservable()
            .withLatestFrom(pObservable) {index, purchases -> [Purchases] in
                return purchases.filter{
                    switch index {
                        case 0:     return $0.collectedAmount >= $0.requiredAmount
                        case 1:     return true
                        default:    return false
                    }
                }
            }
            .subscribe(onNext:{[weak self] p in
                
                self?.purchases.accept(p)
//                var sections: [SectionPurchases] = []
//                p.forEach{
//                    sections.append(SectionPurchases(header: "", items: [$0]))
//                }
//                return sections
            }).disposed(by: disposeBag)
            
            
//            .subscribe(onNext: {[weak self] p in
//                var sections: [SectionPurchases] = []
//                p.forEach{
//                    sections.append(SectionPurchases(header: "", items: [$0]))
//                }
//                self?.purchases.accept(sections)
//            }).disposed(by: disposeBag)
        
        
    }
}
