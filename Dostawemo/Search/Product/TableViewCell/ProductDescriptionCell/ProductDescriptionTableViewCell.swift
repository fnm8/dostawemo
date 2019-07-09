//
//  ProductDescriptionTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 11/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import Down

class ProductDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configurate(product: Product){
        let down = Down(markdownString: product.desc)
        textView.attributedText = try? down.toAttributedString()
    }
}
