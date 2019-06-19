//
//  PhotoTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 13/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class AccountPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var userPhotoImageView: UIImageView!

    func configurate(user: User) {
        setImage(user: user)
    }
    
    private func setImage(user: User){
        
    }
    
}
