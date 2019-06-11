//
//  GroupSegmentProductInfoTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 11/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GroupSegmentProductInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private let disposeBag = DisposeBag()
    
    var segmentState: ((GroupProductInfoSegment)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentControl.rx.value.asDriver()
            .drive(onNext: {[weak self] value in self?.selectedSegment(value: value)})
            .disposed(by: disposeBag)
    }
    
    private func selectedSegment(value: Int){
        switch value {
            case 0:     segmentState?(.info)
            case 1:     segmentState?(.comment)
            default:    segmentState?(.question)
        }
    }
}
