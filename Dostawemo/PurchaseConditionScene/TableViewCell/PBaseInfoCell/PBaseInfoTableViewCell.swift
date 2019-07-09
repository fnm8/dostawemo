//
//  PBaseInfoTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 24/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class PBaseInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var citySenderLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var postPriceLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configurate(purchase: Purchases){
        citySenderLabel.text = purchase.producerCity
    }
    
}
