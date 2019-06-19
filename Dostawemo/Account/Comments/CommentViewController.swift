//
//  CommentViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 06/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CommentViewController: UIViewController {

    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var commentUserContainer: UIView!
    @IBOutlet weak var commentListContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private let disposeBag = DisposeBag()
    private var basket: UIBarButtonItem!
    private let visible: CGFloat = 1
    private let hide: CGFloat = 0
    private let listIndex = 0
    private let userIndex = 1
    private let profileSegue = "ShowProfileFromComment"
    private let authSegue = "ShowAuthFromAccount"
    private let basketSegue = "ShowBasketFromComment"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppTitle()
        commentListContainer.alpha = visible
        commentUserContainer.alpha = hide
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        userImageView.clipsToBounds = true
        
        configurateBasketButton()
        
        // MARK:
        segmentControl.rx.value.asDriver()
            .drive(onNext: {[weak self] i in self?.segmentValueChange(index: i) })
            .disposed(by: disposeBag)
        
        // MARK:
        let tap = UITapGestureRecognizer()
        userInfoView.isUserInteractionEnabled = true
        tap.rx.event.asDriver()
            .drive(onNext: {[weak self] _ in self?.showProfile()})
            .disposed(by: disposeBag)
        userInfoView.addGestureRecognizer(tap)

    }
    
    private func configurateBasketButton(){
        basket = UIBarButtonItem(image: UIImage.basket, style: .plain, target: nil, action: nil)
        basket.rx.tap.asDriver()
            .drive(onNext: {[weak self] in self?.showBasket()})
            .disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = basket
    }
    
    private func showBasket() {
        performSegue(withIdentifier: basketSegue, sender: nil)
    }

    
    private func showProfile(){
        if app.auth == nil {
            performSegue(withIdentifier: authSegue, sender: nil)
            return
        }
        performSegue(withIdentifier: profileSegue, sender: nil)
    }
    
    private func segmentValueChange(index: Int){
        switch index {
        case listIndex:
            commentListContainer.alpha = visible
            commentUserContainer.alpha = hide
            
        case userIndex:
            commentListContainer.alpha = hide
            commentUserContainer.alpha = visible
            
        default:
            break
        }
    }
    
    
    
}
