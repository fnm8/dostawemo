//
//  AttributeCollectionViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 30/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class AttributeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var attributeNameCell: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        attributeNameCell.text?.removeAll()
    }

}
