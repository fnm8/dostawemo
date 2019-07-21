//
//  CountProductTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 06/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CountProductTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    private let disposeBag = DisposeBag()
    
    var amount: ((Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        cStepper()
    }
    
    private func cStepper(){
        stepper.rx.value
            .asDriver()
            .drive(onNext: {[weak self] value in
                self?.countLabel.text = String(Int(value))
                self?.amount?(Int(value))
            }).disposed(by: disposeBag)
    }
}
