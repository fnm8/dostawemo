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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configurate(product: Product){
        dump(product)
        marketPriceLabel.text = product.marketPrice != nil ? String(product.marketPrice!).addRubPostfix() : ""
        dostawemoPriceLabel.text = product.price != nil ? String(product.price!).addRubPostfix() : ""
    }
    
}
