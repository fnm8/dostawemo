//
//  BasketSceneTableViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 04/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasketSceneTableViewController: UITableViewController {

    @IBOutlet weak var closeBarButton: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    private let viewModel = BasketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateCloseButton()
        registerCell()
        cBasketItems()
    }
    
    private func cBasketItems(){
        viewModel.items
            .asDriver()
            .drive(onNext: {[weak self] items in
                if items.isEmpty {
                    self?.tableView.setEmptyLabel(with: "Ваша корзина пуста")
                } else {
                    self?.tableView.setEmptyFooter()
                }
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Close Bar Button
    private func configurateCloseButton(){
        closeBarButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] in self?.dismiss(animated: true, completion: nil)})
            .disposed(by: disposeBag)
    }
    
    private func registerCell(){
        tableView.register(
            BasketTitleImageTableViewCell.nib,
            forCellReuseIdentifier: BasketTitleImageTableViewCell.reuseId
        )
        tableView.register(
            CreateOrderTableViewCell.nib,
            forCellReuseIdentifier: CreateOrderTableViewCell.reuseId
        )
        tableView.register(
            BasketRightDetailTableViewCell.nib,
            forCellReuseIdentifier: BasketRightDetailTableViewCell.reuseId
        )
    }
    
    private let purchaseTitle = 0

}

extension BasketSceneTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return getTitleCell(ip: indexPath)
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BasketTitleImageTableViewCell.reuseId,
                for: indexPath
            ) as! BasketTitleImageTableViewCell
            cell.configurate(section: viewModel.items.value[indexPath.section])
            return cell
        }
        
        return getCreateOrderCell(ip: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 44
        case 1:
            return CGSize.aspectRatioSize(by: tableView.bounds.width).height
            
        default:
            return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    private func getTitleCell(ip: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let item = viewModel.items.value[ip.section]
        cell.textLabel?.text = item.purchaseName
        cell.detailTextLabel?.text = ""
        cell.detailTextLabel?.textColor = .lightGray
        cell.selectionStyle = .none
        return cell
    }
    
    private func getCreateOrderCell(ip: IndexPath) -> CreateOrderTableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CreateOrderTableViewCell.reuseId,
            for: ip) as! CreateOrderTableViewCell
        cell.selectionStyle = .none
        cell.confirmOrder = {[weak self] in self?.showOrder(by: ip) }
        return cell
    }
    
    private func showOrder(by ip: IndexPath){
        let section = viewModel.items.value[ip.section]
        let ordervc = OrderTableViewController(nibName: nil, bundle: nil)
        ordervc.purchaseId = section.purnaseId
        self.navigationController?.pushViewController(ordervc, animated: true)
    }
}

extension BasketSceneTableViewController {
    static func show(on vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "Basket")
        vc.present(nav, animated: true, completion: nil)
    }
    
}
