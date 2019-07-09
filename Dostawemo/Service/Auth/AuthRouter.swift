//
//  AuthRouter.swift
//  Dostawemo
//
//  Created by fnm8 on 18/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
    
    case getVerificationCode(phone: String)
    case register(params: Parameters)
        
    var method: HTTPMethod {
        switch self {
        case .getVerificationCode:  return .get
        case .register:             return .post

        }
    }
    
    var path: String {
        switch self {
        case .getVerificationCode(let phone):
            return "/auth/get-verification-code?phoneNumber=" + phone
        case .register:
            return "/auth/register"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let urlStr = Config.host + path
        let url = URL(string: urlStr)
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .register(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        return urlRequest
    }
}
