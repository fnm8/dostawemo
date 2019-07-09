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
import RxAlamofire
import Alamofire

class AuthService{
    
    static func getVerificationCode(phone: String) -> Observable<Result<Int>> {
        return ApiService.responseJson(request: AuthRouter.getVerificationCode(phone: phone))
            .map{ res -> Result<Int> in
                guard let json = res.result.value as? [String: Any],
                    let code = json["verificationCode"] as? Int
                    else { return .failure(LError.serialize("AuthService getVerificationCode")) }
                return .success(code)
                
            }
    }
    
    static func register(params: Parameters)->Observable<Result<(accessToken: String, refreshToken: String)>>{
        return ApiService.responseJson(request: AuthRouter.register(params: params))
            .map{ res -> Result<(accessToken: String, refreshToken: String)> in
                print(res.result.value)
                guard let json = res.result.value as? [String: Any],
                let token = json["accessToken"] as? String,
                let refresh = json["refreshToken"] as? String
                else { return .failure(LError.serialize("AuthService register")) }
                return .success((accessToken: token, refreshToken: refresh))
        }
    }
    
}
