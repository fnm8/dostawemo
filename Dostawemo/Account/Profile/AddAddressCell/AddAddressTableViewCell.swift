//
//  AddAddressTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 20/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addAddressButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var showAddAddress: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addAddressButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in self?.showAddAddress?() })
            .disposed(by: disposeBag)
    }
}
