//
//  EditProfileTableViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 19/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {

    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var chngePhotoButton: UIButton!
    
    @IBOutlet weak var saveChangesButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateChangePhotoButton()
        configurateSaveChangeButton()
    }
    
    private func configurateChangePhotoButton(){
        chngePhotoButton.layer.cornerRadius = chngePhotoButton.bounds.height / 2
        chngePhotoButton.layer.borderWidth = 1
        chngePhotoButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func configurateSaveChangeButton(){
        saveChangesButton.layer.cornerRadius = saveChangesButton.bounds.height / 2
    }
}
