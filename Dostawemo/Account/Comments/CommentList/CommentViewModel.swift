//
//  CommentViewModel.swift
//  Dostawemo
//
//  Created by fnm8 on 18/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift

class CommentViewModel {
    
    let disposeBag = DisposeBag()
    let user = BehaviorRelay<User?>(value: nil)
    
    
    init(){
       cUser()
    }
    
    private func cUser(){
        do {
            let realm = try Realm()
            let userObj = realm.objects(User.self)
            Observable.array(from: userObj)
                .subscribe(onNext: {[weak self] u in
                    print(u, "Observable comments")
                    self?.user.accept(u.first)
                }).disposed(by: disposeBag)
            
            
        } catch let e {
            print(e.localizedDescription)
        }
        
        
    }
    
}
