//
//  PAboutTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 24/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import Down

class PAboutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var aboutTextField: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configurate(purchase: Purchases){
        let down = Down(markdownString: purchase.about)
        aboutTextField.attributedText = try? down.toAttributedString()
    }
}
