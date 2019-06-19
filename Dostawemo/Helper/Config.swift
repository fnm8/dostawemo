//
//  Config.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 06/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit

class Config {
    
    static let host = "https://us-central1-dostawemo-3c0a1.cloudfunctions.net"
    
    static var appAttributeName: NSMutableAttributedString {
        let fullText = "DOSTAWEMO"
        let changeText = "WE"
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.red , range: range
        )
        return attribute
    }
}
