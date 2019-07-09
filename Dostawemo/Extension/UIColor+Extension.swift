//
//  UIColor+Extension.swift
//  Dostawemo
//
//  Created by fnm8 on 24/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func color(by percent: Int) -> UIColor {
        if percent < 30 {
            return .lightGray
        }
        if percent > 30 && percent < 60 {
            return .yellow
        }
        return .green
    }
    
}
