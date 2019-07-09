//
//  OrderRouter.swift
//  Dostawemo
//
//  Created by fnm8 on 09/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

enum OrderRouter: URLRequestConvertible {
    
    case getOrderId
    
    var method: HTTPMethod {
        switch self {
        case .getOrderId:  return .get
            
        }
    }
    
    var path: String {
        switch self {
        case .getOrderId:
            return "/order/generate-id"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let urlStr = Config.host + path
        let url = URL(string: urlStr)
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
//
//        switch self {
//        case .register(let parameters):
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
//        default:
//            break
//        }
        return urlRequest
    }
}
