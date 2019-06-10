//
//  UIImageView+Extension.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 10/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func imageCornerRadius(){
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
