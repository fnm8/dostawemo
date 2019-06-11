//
//  ProductDescriptionTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 11/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class ProductDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configurate(product: Product){
        textView.text = product.desc
    }
}
