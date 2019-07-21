//
//  EditProfileViewModel.swift
//  Dostawemo
//
//  Created by fnm8 on 12/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift

class EditProfileViewModel {
    
    private let disposeBag = DisposeBag()
    
    let user = BehaviorRelay<User?>(value: nil)
    let success = PublishSubject<()>()
    let enableButton = BehaviorRelay<Bool>(value: false)
    
    
    
    init(
        name: Driver<String>,
        lastName: Driver<String>,
        birthDate: Driver<Date>,
        city: Driver<String>,
        save: Driver<()>
    ){
        let data = Driver
            .combineLatest(name, lastName, birthDate, city){(name: $0, lastName: $1, birthDate: $2, city: $3)}
        
        
        data.map{ data -> Bool in
                if data.name.isEmpty || data.lastName.isEmpty || data.city.isEmpty || data.birthDate == Date(){
                    return false
                }
                return true
            }
            .asObservable()
            .subscribe(onNext: {[weak self] value in self?.enableButton.accept(value) })
            .disposed(by: disposeBag)
        
        save.withLatestFrom(data)
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                self?.saveUserData(n: data.name, l: data.lastName, b: data.birthDate, c: data.city)
            }).disposed(by: disposeBag)
        
        setUserDate()
    }
    
    private func saveUserData(n: String, l: String, b: Date, c: String){
        do {
            let realm = try Realm()
            let userObj = realm.objects(User.self).first
            if userObj != nil {
                
                try realm.write {
                    userObj!.name = n
                    userObj!.lastName = l
                    userObj!.birthday = b
                    userObj!.city = c
                }
            } else {
                let userObj = User()
                userObj.name = n
                userObj.lastName = l
                userObj.birthday = b
                userObj.city = c
                try realm.write {
                    realm.add(userObj)
                }
            }
            success.onNext(())
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    private func setUserDate(){
        do {
            let realm = try Realm()
            let userObj = realm.objects(User.self).first
            user.accept(userObj)
            let enable = userObj == nil ? false : true
            enableButton.accept(enable)
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    
    
}
