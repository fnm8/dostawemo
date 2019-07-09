//
//  ProductImageCollectionViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 01/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.af_cancelImageRequest()
        productImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(path: String) {
        if let url = URL(string: path) {
            productImageView.af_setImage(withURL: url)
        }
    }
}
