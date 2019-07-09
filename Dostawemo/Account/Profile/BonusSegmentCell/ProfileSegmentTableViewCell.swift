//
//  ProfileSegmentTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 20/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileSegmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private let disposedBag = DisposeBag()
    var selectedIndex: ((Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        segmentControl.rx.value.asDriver()
            .drive(onNext: {[weak self] v in self?.selectedIndex?(v)})
            .disposed(by: disposedBag)
    }
    

}
