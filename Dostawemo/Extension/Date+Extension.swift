//
//  Date+Extension.swift
//  Dostawemo
//
//  Created by fnm8 on 24/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation


extension Date {
   
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL yyy"
        return dateFormatter.string(from: self) + " года"
    }
}
