//
//  PNameTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 23/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class PNameTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configurate(purchase: Purchases){
        nameLabel.text = purchase.name
        statusLabel.text = purchase.status
    }
    
}
