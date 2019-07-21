//
//  BasketItemTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 03/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

class BasketItemTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var priceAmountLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.af_cancelImageRequest()
        productImageView.image = nil
        productNameLabel.text?.removeAll()
        sizeLabel.text?.removeAll()
        colorLabel.text?.removeAll()
        priceAmountLabel.text?.removeAll()
    }
    
    func configurate(item: ProductCartItem){
        productNameLabel.text = item.productName
        priceAmountLabel.text = String(item.price) + "руб X " + String(item.amount) + " шт"
        sizeLabel.text = "Размер: " + item.size
        colorLabel.text = "Цвет: " + item.color
        if let url = URL(string: item.productImage) {
            productImageView.af_setImage(withURL: url)
        }
    }
    
    func configurate(item: OrderProduct){
        dump(item)
        productNameLabel.text = item.productName
        priceAmountLabel.text = String(item.price) + "руб X " + String(item.count) + " шт"
        sizeLabel.text = "Размер: " + item.size
        colorLabel.text = "Цвет: " + item.color
        setImage(item: item)
    }
    
    private func setImage(item: OrderProduct){
        if let realm = try? Realm(), let product = realm.objects(Product.self).filter("id = %@", item.productId).first {
            if let path = product.imagesPath.first, let url = URL(string: path) {
                productImageView.af_setImage(withURL: url)
            }
        }
    }
}
