//
//  SignInTextFieldTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 16/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignInTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    private let disposeBag = DisposeBag()
    var value: ((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.rx.text.orEmpty.asDriver()
            .drive(onNext: {[weak self] text in self?.value?(text) })
            .disposed(by: disposeBag)
    }
    
    func configurate(state: SignInState){
        let placeholder = state == .phone ? "79111151897" : "Код"
        textField.placeholder = placeholder
    }
    
}
