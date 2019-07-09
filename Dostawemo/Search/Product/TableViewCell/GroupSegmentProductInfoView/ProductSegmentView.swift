//
//  ProductSegmentView.swift
//  Dostawemo
//
//  Created by fnm8 on 03/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProductSegmentView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private let disposeBag = DisposeBag()
    
    var selectedItem: ((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ProductSegmentView", owner: nil, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configursteSegment()
    }
    
    private func configursteSegment(){
        segmentControl.rx.value.asDriver()
            .drive(onNext: {[weak self] value in
                self?.selectedItem?(value)
            }).disposed(by: disposeBag)
    }
}
