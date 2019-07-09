//
//  BasketViewModel.swift
//  Dostawemo
//
//  Created by fnm8 on 09/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

class BasketViewModel {
    
    let items = BehaviorRelay<[BasketSectionItems]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init() {
        let realm = try! Realm()
        let itemsObj = realm.objects(BasketItem.self)
        Observable.array(from: itemsObj)
            .map{ BasketViewModel.sorted(items: $0) }
            .subscribe(onNext: {[weak self] items in self?.items.accept(items) })
            .disposed(by: disposeBag)
    }
    
    private static func sorted(items: [BasketItem]) -> [BasketSectionItems] {
        var sections: [BasketSectionItems] = []
        items.forEach{ item in
            if let section = sections.first(where: { item.purnaseId == $0.purnaseId }){
                section.items.append(item)
            } else {
                let section = BasketSectionItems(purnaseId: item.purnaseId, purchaseName: item.purchaseName)
                section.items.append(item)
                sections.append(section)
            }
        }
        return sections
    }
}
