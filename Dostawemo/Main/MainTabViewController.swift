//
//  MainViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 10/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainTabViewController: UITabBarController {
    
    var button: UIButton?
    
    private let disposeBag = DisposeBag()
    private let purchaseIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .red
        cShowUserPurchase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //if button == nil {setCenterButton()}
    }
    
    private func cShowUserPurchase(){
        app.coordinator.showUserPurchase
            .subscribe(onNext: {[weak self] _ in self?.setPurchaseTab() })
            .disposed(by: disposeBag)
    }
    
    private func setPurchaseTab(){
        self.selectedIndex = purchaseIndex
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
