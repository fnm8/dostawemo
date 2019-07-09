//
//  PurchaseTableViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 23/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class PurchaseConditionTableViewController: UITableViewController {
    
    var purchases: Purchases!
    
    private let sectionCount = 6
    
    private let titleSectionIndex = 0
    private let nameRow = 0
    private let payInfoRow = 1
    
    private let baseInfoSection = 1
    
    private let deliverySection = 2
    
    private let paymentMethodSection = 3
    
    private let aboutInfoSection = 4
    
    private let endDateSection = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Условия закупки"
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        registerCell()
        configurateBackButton()
    }
    
    
    private func registerCell(){
        tableView.register(PNameTableViewCell.nib, forCellReuseIdentifier: PNameTableViewCell.reuseId)
        tableView.register(PPayInfoTableViewCell.nib, forCellReuseIdentifier: PPayInfoTableViewCell.reuseId)
        tableView.register(PBaseInfoTableViewCell.nib, forCellReuseIdentifier: PBaseInfoTableViewCell.reuseId)
        tableView.register(PDeliveryTableViewCell.nib, forCellReuseIdentifier: PDeliveryTableViewCell.reuseId)
        tableView.register(PaymentMethodTableViewCell.nib, forCellReuseIdentifier: PaymentMethodTableViewCell.reuseId)
        tableView.register(PAboutTableViewCell.nib, forCellReuseIdentifier: PAboutTableViewCell.reuseId)
        tableView.register(PEndDateTableViewCell.nib, forCellReuseIdentifier: PEndDateTableViewCell.reuseId)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case titleSectionIndex:
            return 2
            
        case baseInfoSection, deliverySection, paymentMethodSection, aboutInfoSection, endDateSection:
            return 1
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case titleSectionIndex:
            
            if indexPath.row == nameRow {
                let cell = tableView.dequeueReusableCell(withIdentifier: PNameTableViewCell.reuseId, for: indexPath) as! PNameTableViewCell
                cell.configurate(purchase: purchases)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PPayInfoTableViewCell.reuseId, for: indexPath) as! PPayInfoTableViewCell
                cell.configurate(purchase: purchases)
                return cell
            }
            
        case baseInfoSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: PBaseInfoTableViewCell.reuseId, for: indexPath) as! PBaseInfoTableViewCell
            return cell
            
        case deliverySection:
            let cell = tableView.dequeueReusableCell(withIdentifier: PDeliveryTableViewCell.reuseId, for: indexPath) as! PDeliveryTableViewCell
            return cell
            
        case paymentMethodSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTableViewCell.reuseId, for: indexPath) as! PaymentMethodTableViewCell
            return cell
            
        case aboutInfoSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: PAboutTableViewCell.reuseId, for: indexPath) as! PAboutTableViewCell
            cell.configurate(purchase: purchases)
            return cell
            
        case endDateSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: PEndDateTableViewCell.reuseId, for: indexPath) as! PEndDateTableViewCell
            cell.configurate(purchase: purchases)
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case titleSectionIndex:
            return nil
        case baseInfoSection:
            return headerView(title: "Основная информация о закупке")
            
        case deliverySection:
            return headerView(title: "Доступные варианты доставки")
            
        case paymentMethodSection:
            return headerView(title: "Доступные варианты оплаты")
            
        case aboutInfoSection:
            return headerView(title: "Информация о производителе")
            
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case titleSectionIndex:
            return 0
        case baseInfoSection, deliverySection, paymentMethodSection, aboutInfoSection:
            return 32
            
        default:
            return 0
        }
    }
    
    private func headerView(title: String) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 32)
        let label = UILabel(frame: CGRect(x: 16, y: 8, width: frame.width - 32, height: 16))
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = title
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.addSubview(label)
        return view
    }
    
    deinit {
        print("Deinit")
    }
}
