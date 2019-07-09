//
//  BasketButtonTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 11/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BasketButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var basketButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var addBasket: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        basketButton.layer.cornerRadius = basketButton.bounds.height / 2
        cButton()
    }
    
    private func cButton(){
        basketButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in self?.addBasket?() })
            .disposed(by: disposeBag)
    }
}
