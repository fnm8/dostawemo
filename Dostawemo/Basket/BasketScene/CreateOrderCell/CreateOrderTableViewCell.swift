//
//  CreateOrderTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 03/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CreateOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonContainer: UIView!
    
    private let disposeBag = DisposeBag()
    
    var confirmOrder: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonContainer.layer.cornerRadius = buttonContainer.bounds.height / 2
        cButton()
    }
    
    private func cButton(){
        let tap = UITapGestureRecognizer()
        tap.rx.event.asDriver()
            .drive(onNext: {[weak self] _ in self?.confirmOrder?() })
            .disposed(by: disposeBag)
        buttonContainer.isUserInteractionEnabled = true
        buttonContainer.addGestureRecognizer(tap)
    }
}
