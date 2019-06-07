//
//  SearchViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 04/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Firebase

class SearchViewController: UIViewController {
    
    
    private let disposeBag = DisposeBag()
    
    var basket: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configurateBasketButton()

        

    }
    
    private func configurateBasketButton(){
        basket = UIBarButtonItem(image: UIImage.basket, style: .plain, target: nil, action: nil)
        basket.rx.tap.asDriver()
            .drive(onNext: {[weak self] in self?.showBasket()})
            .disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = basket
    }

    private func showBasket(){
        print("Show basket")
    }

}
