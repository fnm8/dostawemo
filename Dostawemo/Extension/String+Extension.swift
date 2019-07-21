//
//  String+Extension.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 10/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation

extension String {
    
    func addRubPostfix() -> String { return self + " Руб" }
    
    func carry() -> String {
        return self.replacingOccurrences(of: "[n]", with: "\n")
    }
}
