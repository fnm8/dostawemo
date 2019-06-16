//
//  AuthService.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 14/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AuthService{
    
    static func getVerificationCode(phone: String) -> Observable<Result<()>>{
        return Observable.just(.success(()))
    }
    
    static func getAuthData()->Observable<Result<(accessToken: String, refreshToken: String)>>{
        return Observable.just(.success((accessToken: "fdfd", refreshToken: "sddfd")))
    }
    
}
