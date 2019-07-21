//
//  Array+Extension.swift
//  Dostawemo
//
//  Created by fnm8 on 20/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
