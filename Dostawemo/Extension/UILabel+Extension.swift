//
//  UILabel+Extension.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 06/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        self.attributedText = attribute
    }
}
