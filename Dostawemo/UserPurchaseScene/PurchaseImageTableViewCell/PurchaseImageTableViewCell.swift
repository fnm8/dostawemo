//
//  PurchaseImageTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 21/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import AlamofireImage

class PurchaseImageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configurate(purchase: Purchases){
        if let url = URL(string: purchase.image){
            titleImage.af_setImage(withURL: url)
        }
    }
}
