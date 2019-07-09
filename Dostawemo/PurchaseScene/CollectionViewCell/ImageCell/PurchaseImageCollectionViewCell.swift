//
//  PurchaseImageCollectionViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 25/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import AlamofireImage

class PurchaseImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var purchaseImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        purchaseImageView.contentMode = .scaleAspectFit
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        purchaseImageView.af_cancelImageRequest()
        purchaseImageView.image = nil
    }
    
    func configurate(purchase: Purchases){
        if let url = URL(string: purchase.image){ purchaseImageView.af_setImage(withURL: url) }
    }

}
