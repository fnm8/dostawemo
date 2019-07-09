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
}
