//
//  OrderTableViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 09/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderTableViewController: UITableViewController {
    
    var purchaseId: String!
    
    private let disposeBag = DisposeBag()
    private var viewModel: OrderViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrderViewModel(purchaseId: purchaseId)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        cItems()
        cOrderId()
        registerCell()
        cEditProfile()
        cOpenPayUrl()
    }
    
    private func registerCell(){
        tableView.register(
            CreateOrderButtonTableViewCell.nib,
            forCellReuseIdentifier: CreateOrderButtonTableViewCell.reuseId
        )
        tableView.register(
            BasketItemTableViewCell.nib,
            forCellReuseIdentifier: BasketItemTableViewCell.reuseId
        )
    }
    
    private func cItems(){
        viewModel.cartItem
            .asDriver()
            .filter{$0 != nil}
            .drive(onNext: {[weak self] cardItem in
                self?.setOrderId(id: cardItem!.orderId)
                self?.tableView.reloadData()
                
            }).disposed(by: disposeBag)
    }
    
    private func cOrderId(){
//        DispatchQueue.main.async {
//            let indicator = UIActivityIndicatorView()
//            indicator.tintColor = .red
//            indicator.startAnimating()
//            indicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            self.navigationItem.titleView = indicator
//        }
        
    }
    
    private func cOpenPayUrl(){
        viewModel.openPayUrl
            .subscribe(onNext: {[weak self] url in self?.showPaymentView(with: url) })
            .disposed(by: disposeBag)
    }
    
    private func showPaymentView(with url: String){
        let vc = PrePaymentViewController(nibName: nil, bundle: nil)
        vc.url = url
        vc.orderId = viewModel.cartItem.value?.orderId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setOrderId(id: String){
        DispatchQueue.main.async {
            self.navigationItem.title = "Заказ № " + id
        }
    }
    
    var sectionsCount: Int {
        return viewModel.cartItem.value == nil ? 0 : 2
    }
    
    enum Sections: Int {
        case items
        case payment
    }
    
    private func cEditProfile(){
        viewModel.openEditProfile
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {[weak self] in self?.showAuth() })
            .disposed(by: disposeBag)
    }
    
    private func showAuth(){
        let nav = UINavigationController()
        let vc = SignInTableViewController(nibName: nil, bundle: nil)
        nav.setViewControllers([vc], animated: true)
        self.present(nav, animated: true, completion: nil)
    }
}

extension OrderTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.items.rawValue {
            return viewModel.cartItem.value!.products.count
        }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.items.rawValue {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BasketItemTableViewCell.reuseId,
                for: indexPath
            ) as! BasketItemTableViewCell
            cell.selectionStyle = .none
            cell.configurate(item: viewModel.cartItem.value!.products[indexPath.row])
            return cell
        }
        
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Итого: "
            cell.detailTextLabel?.text = "\(viewModel.cartItem.value!.totalPrice)".addRubPostfix()
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Предоплата: "
            cell.detailTextLabel?.text = "100".addRubPostfix()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CreateOrderButtonTableViewCell.reuseId,
            for: indexPath
        ) as! CreateOrderButtonTableViewCell
        cell.selectionStyle = .none
        cell.createOrder = {[weak self]  in self?.viewModel.createOrder() }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == Sections.items.rawValue {
            return 100
        }
        if indexPath.row == 0 || indexPath.row == 1 {
            return 44
        }
        
        return 60
    }
}
