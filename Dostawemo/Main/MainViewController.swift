//
//  MainViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 10/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    var button: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if button == nil {setCenterButton()}
    }
    
    private func setCenterButton(){
        let x = UIApplication.shared.keyWindow!.bounds.width / 2 - 45
        let y = UIApplication.shared.keyWindow!.bounds.height - 80
        let w: CGFloat = 90
        let h: CGFloat = 90
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: w, height: h))
        imageView.layer.cornerRadius = 45
        imageView.layer.zPosition = 100000
        imageView.image = UIImage.frameRed
        view.addSubview(imageView)
    }
}
