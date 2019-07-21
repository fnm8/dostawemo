//
//  OrderService.swift
//  Dostawemo
//
//  Created by fnm8 on 09/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class OrderService {
    
    static func getOrderId() -> Observable<Result<String>> {
        return ApiService.responseJson(request: OrderRouter.getOrderId)
            .map{ res -> Result<String> in
                guard let json = res.result.value as? [String: Any],
                    let code = json["orderNumber"] as? String
                    else { return .failure(LError.serialize("OrderService getOrderId")) }
                return .success(code)
                
        }
    }
    
    static func createOrder(params: Parameters) -> Observable<Result<String>>{
        print(params)
        return ApiService.responseJson(request: OrderRouter.orderCreate(parameters: params))
            .map{ res -> Result<String> in
                guard let json = res.value as? [String: Any], let url = json["formUrl"] as? String
                    else {return .failure(LError.serialize("OrderService createOrder"))}
                return .success(url)
            }
        
    }
}
