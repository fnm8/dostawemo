//
//  UIViewController+Extension.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 06/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setAppTitle(){
        let image = UIImage(named: "logo")
        let imageView = UIImageView()
        imageView.image = image
        navigationItem.titleView = imageView
    }
}

