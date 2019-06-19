//
//  ProfileTableViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 13/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var addAddressButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let addAddressSegue = "ShowAddAddressFromProfile"
    
    
    private let accountPhotoIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        configurateAddAddressButton()

    }
    
    private func configurateAddAddressButton(){
        addAddressButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in self?.showAddAddress() })
            .disposed(by: disposeBag)
    }
    
    private func showAddAddress(){
        performSegue(withIdentifier: addAddressSegue, sender: nil)
    }
    
    private func registerTableViewCell(){
        tableView.register(
            AccountPhotoTableViewCell.nib,
            forCellReuseIdentifier: AccountPhotoTableViewCell.reuseId
        )
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)


        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//    }
}
