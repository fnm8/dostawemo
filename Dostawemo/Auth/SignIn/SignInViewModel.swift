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

class SignInViewModel {
    
    let state: Driver<SignInState>
    
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
        
        
        
        
        //MARK: - Error
        getCode.filter{$0.error != nil}
            .map{$0.error!}
            .subscribe(onNext: { print($0) })
        
        
        
        
    }
}
