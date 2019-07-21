//
//  SignInViewModel.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 14/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Realm
import RealmSwift
import Firebase

class SignInViewModel {
    
    let successSendCode = PublishSubject<Int>()
    let successSignIn = PublishSubject<()>()
    
    
    let phone = PublishSubject<String>()
    let sendCode = PublishSubject<()>()
    let code = PublishSubject<String>()
    let signIn = PublishSubject<()>()
    
    private let disposeBag = DisposeBag()
    
    init(){
        cSendCode()
        cSignIn()
    }
    
    private func cSendCode(){
        let sendCodeResult = sendCode
            .withLatestFrom(phone)
            .flatMapFirst{AuthService.getVerificationCode(phone: $0)}
            .share()
            .debug()
        
        sendCodeResult
            .filter{$0.value != nil}
            .map{$0.value!}
            .subscribe(onNext: {[weak self] code in self?.successSendCode.onNext(code)})
            .disposed(by: disposeBag)
        
        sendCodeResult
            .filter{$0.error != nil}
            .map{$0.error!}
            .subscribe(onNext: {print($0.localizedDescription)})
            .disposed(by: disposeBag)
    }
    
    private func cSignIn(){
        
        let params = Observable.combineLatest(phone, code){phone, code -> [String: Any] in
            return [
                "phoneNumber": phone,
                "verificationCode": code
            ]
        }
        
        let signInResult = signIn
            .withLatestFrom(params)
            .flatMapFirst{AuthService.register(params: $0)}
            .share()
            .debug()
        
        signInResult
            .filter{$0.value != nil}
            .map{$0.value!}
            .subscribe(onNext: {[weak self] auth in self?.saveAuthCredentials(auth: auth) })
            .disposed(by: disposeBag)
        
        signInResult
            .filter{$0.error != nil}
            .map{$0.error!}
            .subscribe(onNext: {print($0.localizedDescription)})
            .disposed(by: disposeBag)
    }
    
    private func saveAuthCredentials(auth: (accessToken: String, refreshToken: String, customToken: String)){
        do {
            let realm = try Realm()
            let authCredentials = AuthCredentials()
            authCredentials.custom = auth.customToken
            authCredentials.token = auth.accessToken
            authCredentials.refresh = auth.refreshToken
            try realm.write {
                realm.add(authCredentials)
            }
            successSignIn.onNext(())
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
   
}
