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
    case orderCreate(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
            case .getOrderId:  return .get
            case .orderCreate: return .post
        }
    }
    
    var path: String {
        switch self {
            case .getOrderId:   return "/order/generate-id"
            case .orderCreate:  return "/order/prepayment"
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let urlStr = Config.host + path
        let url = URL(string: urlStr)
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        switch self {
        case .orderCreate(let parameters):
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        default:
            break
        }
        
        return urlRequest
    }
    
    func json(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
