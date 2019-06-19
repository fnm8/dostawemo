//
//  SignInTableViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 14/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PhoneNumberKit

enum SignInState{
    case phone, code
}

class SignInTableViewController: UITableViewController {
    
    @IBOutlet weak var phoneTextField: PhoneNumberTextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var phoneNumberContainer: UIView!
    @IBOutlet weak var codeContainer: UIView!
    
    private let disposeBag = DisposeBag()
    var viewModel: SignInViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppTitle()
        configurateTextField()
        signInButton.layer.cornerRadius = signInButton.bounds.height / 2
        codeContainer.alpha = 0
        
        viewModel = SignInViewModel(
            phoneNumber: phoneTextField.rx.text.orEmpty.asDriver(),
            sendPhoneAction: signInButton.rx.tap.asSignal(),
            codeVerification: codeTextField.rx.text.orEmpty.asDriver()
        )
        
        viewModel.state
            .drive(onNext: {[weak self] state in self?.showCodeContainer() })
            .disposed(by: disposeBag)
        
        // Verification Code
        viewModel.verificationCode
            .filter{$0 != nil}
            .drive(onNext: {[weak self] code in self?.showVerifityCodeAlert(code: code!)})
            .disposed(by: disposeBag)
        
//        codeTextField.rx.text.orEmpty
//            .asDriver()
//            .drive(onNext: {[weak self] code in
//                if code.count == 6 { self?.codeTextField.isUserInteractionEnabled = false }
//            }).disposed(by: disposeBag)
    }
    
    private func showVerifityCodeAlert(code: Int){
        codeTextField.text = "\(code)"
        codeTextField.sendActions(for: .valueChanged)
//        let alert = UIAlertController(
//            title: "Проверочный код",
//            message: "Никому не сообщайте проверочный код. Код: \(code)",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
    
    private func configurateTextField(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(
            x: 0.0, y: phoneTextField.frame.height - 1,
            width: phoneTextField.frame.width, height: 1.0
        )
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        phoneTextField.layer.addSublayer(bottomLine)
        codeTextField.layer.addSublayer(bottomLine)
    }
    
    private func showCodeContainer(){
        UIView.animate(withDuration: 0.1) {
            self.codeContainer.alpha = 1
        }
    }

    
}
