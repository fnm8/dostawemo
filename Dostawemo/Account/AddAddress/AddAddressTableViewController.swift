//
//  AddAddressTableViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 19/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class AddAddressTableViewController: UITableViewController {

    @IBOutlet weak var addAddressButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ДОБАВИТЬ НОВЫЙ АДРЕС"
        addAddressButton.layer.cornerRadius = addAddressButton.bounds.height / 2
        
    }

}
