//
//  FirstDetailView.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 13/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class FirstDetailView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var registerDate: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("FirstDetailView", owner: nil, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configurate(){
        
    }

}
