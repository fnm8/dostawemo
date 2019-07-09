//
//  CGSize+Extension.swift
//  Dostawemo
//
//  Created by fnm8 on 01/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    
    static func aspectRatioHeight(by width: CGFloat) -> CGFloat {
        let part = width / 4
        return part * 3
    }
    
    static func aspectRatioSize(by width: CGFloat) -> CGSize {
        let part = width / 4
        let height = part * 3
        return CGSize(width: width, height: height)
    }
}
