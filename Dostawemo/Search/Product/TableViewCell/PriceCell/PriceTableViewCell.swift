//
//  PriceTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 07/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet weak var marketPriceLabel: UILabel!
    @IBOutlet weak var dostawemoPriceLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        appNameLabel.attributedText = Config.appAttributeName
    }

    func configurate(product: Product){
        marketPriceLabel.text = product.marketPrice != nil ? String(product.marketPrice!) : ""
        dostawemoPriceLabel.text = product.price != nil ? String(product.price!) : ""
    }
    
}
