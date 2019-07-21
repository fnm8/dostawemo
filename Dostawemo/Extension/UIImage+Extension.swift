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
    
//    static func setImage(on imageView: UIImageView, with imagePath: String){
//        dump(imagePath)
//        DispatchQueue.main.async {
//            if let image = app.imagesHash[imagePath] {
//                imageView.image = image
//                return
//            } else {
//                if let url = URL(string: imagePath){
//                    DispatchQueue.global().async {
//                        if let data = try? Data( contentsOf: url), let image = UIImage(data:data){
//                            DispatchQueue.main.async {
//                                app.imagesHash[imagePath] = image
//                                imageView.image = image
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
}
