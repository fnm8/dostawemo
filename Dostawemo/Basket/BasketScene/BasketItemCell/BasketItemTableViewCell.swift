//
//  BasketItemTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 03/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import AlamofireImage

class BasketItemTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var priceAmountLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        productImageView.af_cancelImageRequest()
//        productImageView.image = nil
        productNameLabel.text?.removeAll()
        sizeLabel.text?.removeAll()
        colorLabel.text?.removeAll()
        priceAmountLabel.text?.removeAll()
    }
    
    func configurate(item: BasketItem){
        productNameLabel.text = item.productName
        priceAmountLabel.text = String(item.price) + "руб X" + String(item.amount) + " шт"
        sizeLabel.text = "Размер: " + item.size
        colorLabel.text = "Цвет: " + item.color
        
        
//        if let url = URL(string: path) {
//            productImageView.af_setImage(withURL: url)
//        }
    }
    
}
