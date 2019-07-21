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
        return dateFormatter.string(from: self)
    }
    
    func yearOld() -> Int {
        let calendar = Calendar.current        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.year], from: date1, to: date2)
        return components.year!
    }
}
