//
//  CreateOrderTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 03/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class CreateOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonContainer.layer.cornerRadius = buttonContainer.bounds.height / 2
    }
}
