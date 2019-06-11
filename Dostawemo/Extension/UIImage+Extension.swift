//
//  UIImage+Extension.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 04/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    static let basket = UIImage(named: "basket")?.withRenderingMode(.alwaysTemplate)
    static let favs = UIImage(named: "favs")?.withRenderingMode(.alwaysTemplate)
    static let favsFilled = UIImage(named: "favs_filled")?.withRenderingMode(.alwaysTemplate)
    static let shared = UIImage(named: "shared")?.withRenderingMode(.alwaysTemplate)
    
    static let frameRed = UIImage(named: "Frame")?.withRenderingMode(.alwaysTemplate)
}
