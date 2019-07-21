//
//  CreateOrderButtonTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 10/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CreateOrderButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var createOrderButton: UIButton!
    
    var createOrder: (()->())?
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createOrderButton.layer.cornerRadius = createOrderButton.bounds.height / 2
        cCreateOrder()
    }

    private func cCreateOrder(){
        createOrderButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in self?.createOrder?()})
            .disposed(by: disposeBag)
    }
    
}
