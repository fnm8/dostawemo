//
//  PEndDateTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 24/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class PEndDateTableViewCell: UITableViewCell {

    @IBOutlet weak var endDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configurate(purchase: Purchases){
        endDateLabel.text = purchase.endDate.dateString()
    }
    
}
