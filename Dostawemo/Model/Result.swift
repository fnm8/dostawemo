//
//  Result.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 14/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation


import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {
    
    func flatMap<U>(_ transform: (T) -> Result<U>) -> Result<U> {
        switch self {
        case let .success(value): return transform(value)
        case let .failure(error): return .failure(error)
        }
    }
}

extension Result {
    
    var value: T? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var error: Error? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
