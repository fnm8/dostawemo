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

class SignInViewModel {
    
    let state: Driver<SignInState>
    let verificationCode: Driver<Int?>
    
    init(
        phoneNumber:        Driver<String>,
        sendPhoneAction:    Signal<()>,
        codeVerification:Driver<String>
    )
    {
        
        let getCode = sendPhoneAction
            .withLatestFrom(phoneNumber)
            .asObservable()
            .flatMapFirst{AuthService.getVerificationCode(phone: $0)}
            .share()
        
        state = getCode
            .filter{$0.value != nil}
            .map{ _ in return .code}
            .asDriver(onErrorJustReturn: .code)
        
        verificationCode = getCode
            .filter{$0.value != nil}
            .map{$0.value}
            .asDriver(onErrorJustReturn: nil)
        
        let registerResult = codeVerification
            .filter{$0.count >= 6}
            .withLatestFrom(phoneNumber){ return [ "phoneNumber": $01, "verificationCode": $0 ] }
            .asObservable()
            .do(onNext: {print($0)})
            .flatMapFirst{AuthService.register(params: $0)}
            .share()
        
        registerResult
            .filter{$0.value != nil}
            .map{SignInViewModel.setAuth(authData: $0.value!)}
            .subscribe()
        
        //MARK: - Error
        let getCodeError = getCode.filter{$0.error != nil}.map{$0.error!}
        let registerError = registerResult.filter{$0.error != nil}.map{$0.error!}
    }
    
    private static func setAuth(authData: (accessToken: String, refreshToken: String)) -> Result<()> {
        do {
            
            let realm = try Realm()
            let auths = realm.objects(Auth.self)
            
            let auth = Auth()
            auth.token = authData.accessToken
            auth.refresh = authData.refreshToken
            
            try realm.write {
                if auths.count == 0 { realm.delete(auths) }
                realm.add(auth)
            }
            return .success(())
        } catch {
            return .failure(LError.db("SignInViewModel setAuth"))
        }
    }
}
