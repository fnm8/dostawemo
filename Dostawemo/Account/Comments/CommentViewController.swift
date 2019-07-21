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
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInView: UIView!
    
    private let disposeBag = DisposeBag()
    private var basket: UIBarButtonItem!
    private let visible: CGFloat = 1
    private let hide: CGFloat = 0
    private let listIndex = 0
    private let userIndex = 1
    private let profileSegue = "ShowProfileFromComment"
    private let authSegue = "ShowAuthFromAccount"
    private let basketSegue = "ShowBasketFromComment"
    
    private var viewModel = CommentViewModel()
    
    var userIsLoginTapDisposable: Disposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppTitle()
        commentListContainer.alpha = visible
        commentUserContainer.alpha = hide
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        userImageView.clipsToBounds = true
        
        configurateBasketButton()
        cUser()
        cSignInButton()
        
        // MARK:
        segmentControl.rx.value.asDriver()
            .drive(onNext: {[weak self] i in self?.segmentValueChange(index: i) })
            .disposed(by: disposeBag)

    }
    
    private func cUser(){
        viewModel.user.asDriver()
            .drive(onNext: {[weak self] u in
                if u == nil {
                    self?.unsetUserData()
                } else {
                    self?.setUserData(user: u!)
                }
            }).disposed(by: disposeBag)
    }
    
    private func unsetUserData(){
        DispatchQueue.main.async {
            self.signInView.isHidden = false
            self.userIsLoginTapDisposable?.dispose()
            self.userIsLoginTapDisposable = nil
        }
    }
    
    private func setUserData(user: User){
        DispatchQueue.main.async {
            self.signInView.isHidden = true
            self.firstNameLabel.text = user.name.isEmpty ? "Имя" : user.name
            self.secondNameLabel.text = user.lastName.isEmpty ? "Фамилия" : user.lastName
            self.cityLabel.text = user.city.isEmpty ? "Не указан" : user.city
            let tap = UITapGestureRecognizer()
            self.userInfoView.isUserInteractionEnabled = true
            self.userIsLoginTapDisposable = tap.rx.event.asDriver()
                .drive(onNext: {[weak self] _ in self?.showProfile()})
            self.userInfoView.addGestureRecognizer(tap)
            
            let year = user.birthday.yearOld()
            self.age.text = "Возраст: \(year)"
        }
        
    }
    
    private func cSignInButton(){
        signInButton.layer.cornerRadius = signInButton.bounds.height / 2
        signInButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in self?.showSignIn() })
            .disposed(by: disposeBag)
    }
    
    private func showSignIn(){
        let nav = UINavigationController()
        let vc = SignInTableViewController(nibName: nil, bundle: nil)
        nav.setViewControllers([vc], animated: true)
        self.present(nav, animated: true, completion: nil)
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
        if !app.coordinator.userIsLogin {
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
