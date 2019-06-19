//
//  ApiService.swift
//  Dostawemo
//
//  Created by fnm8 on 18/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxCocoa
import RxSwift

class ApiService {
    
    static func responseJson(request:  URLRequestConvertible) -> Observable<(DataResponse<Any>)>{
        return RxAlamofire.request(request)
            .validate()
            .responseJSON()
    }

}
