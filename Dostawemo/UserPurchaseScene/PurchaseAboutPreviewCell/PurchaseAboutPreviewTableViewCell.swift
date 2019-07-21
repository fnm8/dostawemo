//
//  PurchaseAboutPreviewTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 21/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class PurchaseAboutPreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var productsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configurate(purchase: Purchases){
        membersCountLabel.text = String(purchase.purchaseCount)
        productsCountLabel.text = String(purchase.productsCount)
    }
}
