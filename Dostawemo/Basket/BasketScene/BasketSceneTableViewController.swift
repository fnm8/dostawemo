//
//  BasketSceneTableViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 04/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasketSceneTableViewController: UITableViewController {

    @IBOutlet weak var closeBarButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateCloseButton()
    }
    
    //MARK: - Close Bar Button
    private func configurateCloseButton(){
        closeBarButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] in self?.dismiss(animated: true, completion: nil)})
            .disposed(by: disposeBag)
    }
}

extension BasketSceneTableViewController {
    
    static func show(on vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "Basket")
        vc.present(nav, animated: true, completion: nil)
    }
    
}
