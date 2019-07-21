//
//  BasketTitleImageTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 11/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import AlamofireImage

class BasketTitleImageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleImageView.af_cancelImageRequest()
        titleImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configurate(section: CartItem){
        if let url = URL(string: section.purnaseImage) {
            titleImageView.af_setImage(withURL: url)
        }
    }
    
}
