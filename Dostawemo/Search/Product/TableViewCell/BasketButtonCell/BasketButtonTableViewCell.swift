//
//  BasketButtonTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 11/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class BasketButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var basketButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        basketButton.layer.cornerRadius = basketButton.bounds.height / 2
    }

}
