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
    
    enum ProfileState{
        case bonus, delivery
    }
    
    
    private let userInfoSection = 0
    private let userPhotoRow = 0
    private let userInfo = 1
    
    private let userSubDetailHeaderSection = 1
    private let segmentRow = 0
    
    private let userSubDetailSection = 2
    
    
    private var state: ProfileState = .bonus
    
    private let disposeBag = DisposeBag()
    private let addAddressSegue = "ShowAddAddressFromProfile"
    
    
    private let accountPhotoIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        //configurateAddAddressButton()

    }
//
//    private func configurateAddAddressButton(){
//        addAddressButton.rx.tap
//            .asDriver()
//            .drive(onNext: {[weak self] in self?.showAddAddress() })
//            .disposed(by: disposeBag)
//    }
    
    private func showAddAddress(){
        performSegue(withIdentifier: addAddressSegue, sender: nil)
    }
    
    private func registerTableViewCell(){
        tableView.register(
            AccountPhotoTableViewCell.nib,
            forCellReuseIdentifier: AccountPhotoTableViewCell.reuseId
        )
        
        tableView.register(
            UserDetailSliderTableViewCell.nib,
            forCellReuseIdentifier: UserDetailSliderTableViewCell.reuseId
        )
        
        tableView.register(
            ProfileSegmentTableViewCell.nib,
            forCellReuseIdentifier: ProfileSegmentTableViewCell.reuseId
        )
        
        tableView.register(
            AddAddressTableViewCell.nib,
            forCellReuseIdentifier: AddAddressTableViewCell.reuseId
        )
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case userInfoSection:               return 2
        case userSubDetailHeaderSection:    return 1
        case userSubDetailSection:          return state == .bonus ? 0 : 1
        default:                            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == userInfoSection {
            if indexPath.row == userPhotoRow {
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountPhotoTableViewCell.reuseId, for: indexPath) as! AccountPhotoTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailSliderTableViewCell.reuseId, for: indexPath) as! UserDetailSliderTableViewCell
                cell.configurate()
                return cell
            }
        }
        
        if indexPath.section == userSubDetailHeaderSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSegmentTableViewCell.reuseId, for: indexPath) as! ProfileSegmentTableViewCell
            cell.selectedIndex = {[weak self] v in self?.setState(v: v) }
            return cell
        }
        
        if indexPath.section == userSubDetailSection {
            if indexPath.row == 0 && state == .delivery {
                let cell = tableView.dequeueReusableCell(withIdentifier: AddAddressTableViewCell.reuseId, for: indexPath) as! AddAddressTableViewCell
                cell.showAddAddress = {[weak self] in self?.showAddAddress()}
                return cell
            }
            
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }
    
    private func setState(v: Int){
        switch v {
        case 0:
            state = .bonus
        default:
            state = .delivery
        }
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadSections([self.userSubDetailSection], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case userInfoSection:
            if indexPath.row == userPhotoRow {
                return tableView.bounds.width / 4 * 3
            } else {
                return 120
            }
            
        case userSubDetailHeaderSection:
            return 50
            
        case userSubDetailSection:
            return 50
            
        default:    return 0
        }
    }
}
