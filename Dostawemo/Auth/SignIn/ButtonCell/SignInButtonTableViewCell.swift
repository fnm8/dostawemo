//
//  SignInButtonTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 16/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    private let disposeBag = DisposeBag()
    var buttonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = button.bounds.height / 2
        button.rx.tap.asDriver()
            .drive(onNext: {[weak self] in self?.buttonAction?()})
            .disposed(by: disposeBag)
    }
    
    func configurate(title: String){
        button.setTitle(title, for: .normal)
    }
}
