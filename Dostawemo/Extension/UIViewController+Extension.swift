//
//  UIViewController+Extension.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 06/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension UIViewController {
    
    func setAppTitle(){
        let image = UIImage(named: "logo")
        let imageView = UIImageView()
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func configurateBackButton(){
        let back = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = back
    }
    
    @objc private func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
}

