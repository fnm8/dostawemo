//
//  TopProductCollectionViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 05/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

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

    func configurate(product: Product){
        productImageView.image = nil
        priceLabel.text = product.price == nil ? "" : String(product.price!).addRubPostfix()
        marketPriceLabel.text = product.marketPrice == nil ? "" : String(product.marketPrice!).addRubPostfix()
        nameProductLabel.text = product.name
        detailProductLabel.text = ""
        loadImage(product: product)
        DispatchQueue.main.async {
            self.activity = UIActivityIndicatorView()
            self.activity!.frame = self.productImageView.bounds
            self.activity!.startAnimating()
            self.productImageView.addSubview(self.activity!)
        }
    }
    
    private func loadImage(product: Product){
        if product.images.isEmpty { return }

        if let url = URL( string: product.images.first!) {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf:url) {
                    DispatchQueue.main.async {
                        self.productImageView.image = UIImage( data:data)
                        self.activity?.removeFromSuperview()
                        self.activity = nil
                    }
                }
            }
        }
    }
}
