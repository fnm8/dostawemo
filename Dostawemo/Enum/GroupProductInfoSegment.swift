//
//  GroupProductInfoSegment.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 11/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation


enum GroupProductInfoSegment {
    case info, comment, question
    
    var index: Int {
        switch self {
        case .info:
            return 0
        case .comment:
            return 1
        case .question:
            return 2
        }
    }
}
