//
//  UserPurchaseTableViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 21/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserPurchaseTableViewController: UITableViewController {
    
    var purchaseId: String!
    private var viewModel: UserPurchaseViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        viewModel = UserPurchaseViewModel(purchaseId: purchaseId)
        registerCell()
        configurateCloseButton()
        cPurchase()
    }
    
    private func cPurchase(){
        viewModel.purchase.asDriver().filter{$0 != nil}
            .drive(onNext: {[weak self] purchase in
                self?.reloadPurchaseSection()
                self?.setTitle(purchase: purchase!)
            }).disposed(by: disposeBag)
    }
    
    private func setTitle(purchase: Purchases){
        navigationItem.title = purchase.name
    }
    
    private func reloadPurchaseSection(){
        tableView.beginUpdates()
        let set = IndexSet(integer: 0)
        tableView.reloadSections(set, with: .automatic)
        tableView.endUpdates()
    }
    
    private func configurateCloseButton(){
        let image = UIImage(named: "close")
        let closeButton = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in self?.dismiss(animated: true, completion: nil) })
            .disposed(by: disposeBag)
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    private func registerCell(){
        tableView.register(PurchaseImageTableViewCell.nib,
                           forCellReuseIdentifier: PurchaseImageTableViewCell.reuseId)
        
        tableView.register(PurchaseAboutPreviewTableViewCell.nib,
                           forCellReuseIdentifier: PurchaseAboutPreviewTableViewCell.reuseId)
        
        tableView.register(BasketItemTableViewCell.nib,
                           forCellReuseIdentifier: BasketItemTableViewCell.reuseId)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        var counter = 0
        if viewModel.purchase.value != nil {
            counter += 1
        }
        counter += viewModel.orders.value.count
        return counter
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if viewModel.purchase.value != nil {
                return 7
            }
        }
        let orders = viewModel.orders.value
        if orders.isEmpty {
            return 0
        }

        if orders[section - 1].products.isEmpty {
            return 0
        }
        return viewModel.orders.value[section - 1].products.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
                case 0: return imageCell(indexPath: indexPath)
                case 1: return titleNameCell()
                case 2: return daysLeavseCell()
                case 3: return completedCell()
                case 4: return progressViewCell()
                case 5: return aboutPreviewCell(indexPath: indexPath)
                case 6: return statusCell()
                default: return UITableViewCell()
            }
        }
        
        let products = viewModel.orders.value[indexPath.section - 1].products
        if indexPath.row == products.count {
            return paymentCell(indexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketItemTableViewCell.reuseId, for: indexPath) as! BasketItemTableViewCell
        cell.configurate(item: products[indexPath.row])
        return cell        
    }
    
    private func imageCell(indexPath: IndexPath) -> PurchaseImageTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseImageTableViewCell.reuseId, for: indexPath) as! PurchaseImageTableViewCell
        
        cell.configurate(purchase: viewModel.purchase.value!)
        return cell
    }
    
    private func titleNameCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = viewModel.purchase.value!.name
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    private func daysLeavseCell() -> UITableViewCell {
        let p = viewModel.purchase.value!
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(p.collectedAmount) сбор"
        cell.detailTextLabel?.text = "Осталось дней \(p.leavesDay)"
        cell.textLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 11)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 11)
        return cell
    }
    
    private func completedCell() -> UITableViewCell {
        let p = viewModel.purchase.value!
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let perc = p.requiredAmount / 100
        var res = p.collectedAmount / perc
        res = res > 100 ? 100 : res
        cell.selectionStyle = .none
        cell.textLabel?.text = "ЗАКУПКА СОСТОИТСЯ НА"
        cell.detailTextLabel?.text = "\(res) %"
        cell.textLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell
    }
    
    private func progressViewCell() -> UITableViewCell {
        let p = viewModel.purchase.value!
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10)
        let progressView = UIProgressView(frame: frame)
        cell.contentView.addSubview(progressView)
        
        let progress = Progress(totalUnitCount: Int64(p.requiredAmount))
        let perc = p.requiredAmount / 100
        let res = p.collectedAmount / perc
        
        if p.collectedAmount == 0 {
            progressView.setProgress(Float(progress.fractionCompleted), animated: true)
            return cell
        }
        progress.completedUnitCount = Int64(p.collectedAmount)
        progressView.setProgress(Float(progress.fractionCompleted), animated: true)
        progressView.tintColor = UIColor.color(by: res)
        return cell
    }
    
    private func aboutPreviewCell(indexPath: IndexPath) -> PurchaseAboutPreviewTableViewCell {
        let p = viewModel.purchase.value!
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: PurchaseAboutPreviewTableViewCell.reuseId,
                for: indexPath
        ) as! PurchaseAboutPreviewTableViewCell
        cell.configurate(purchase: p)
        return cell
    }
    
    private func statusCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = viewModel.purchase.value!.status
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    private func paymentCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let width = tableView.bounds.width - 40
        let frame = CGRect(x: 20, y: 10, width: width, height: 50)
        let button = UIButton(frame: frame)
        button.backgroundColor = .red
        button.setTitle("Оплатить заказ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = button.bounds.height / 2
        cell.contentView.addSubview(button)
        button.rx.tap.asDriver()
            .drive(onNext: {[weak self] _ in
                let order = self?.viewModel.orders.value[indexPath.section - 1]
                print(order)
            }).disposed(by: disposeBag)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 16, y: 10, width: 200, height: 20))
        label.text = "ЗАКАЗ № \(viewModel.orders.value[section - 1].id)"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0{
                let width = tableView.bounds.width
                let part = width / 4
                return part * 3
            }
            if indexPath.row == 1 {
                return 60
            }
            if indexPath.row == 2{
                return 20
            }
            if indexPath.row == 3{
                return 30
            }
            if indexPath.row == 4{
                return 10
            }
            if indexPath.row == 5{
                return 50
            }
            if indexPath.row == 6{
                return 30
            }
        }
        
        let products = viewModel.orders.value[indexPath.section - 1].products
        if indexPath.row == products.count {
            return 60
        }
        return 100
    }
}
