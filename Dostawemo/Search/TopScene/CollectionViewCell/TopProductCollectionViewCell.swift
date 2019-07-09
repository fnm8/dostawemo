//
//  TopProductCollectionViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 05/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import AlamofireImage

class TopProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var marketPriceLabel: UILabel!
    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var detailProductLabel: UILabel!
    
    private var activity: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.imageCornerRadius()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.af_cancelImageRequest()
        productImageView.image = nil
    }

    func configurate(product: Product){
        productImageView.image = nil
        priceLabel.text = String(product.price).addRubPostfix()
        marketPriceLabel.text = String(product.marketPrice).addRubPostfix()
        nameProductLabel.text = product.name
        detailProductLabel.text = ""
        if let path = product.imagesPath.first, let url = URL(string: path) {
            productImageView.af_setImage(withURL: url)
        }
    }
}
