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
    
    let items = BehaviorRelay<[CartItem]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init() {
        let realm = try! Realm()
        let itemsObj = realm.objects(CartItem.self)
        
        Observable.array(from: itemsObj)
            .subscribe(onNext: {[weak self] items in self?.items.accept(items) })
            .disposed(by: disposeBag)
    }
}
