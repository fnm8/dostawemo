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
        cItems()
    }
    
    private func cItems(){
        viewModel.basketSection.asDriver()
            .drive(onNext: {[weak self] _ in self?.tableView.reloadData() })
            .disposed(by: disposeBag)
    }
    
    var sectionsCount: Int {
        return viewModel.basketSection.value == nil ? 0 : 2
    }
    
    enum Sections: Int {
        case items
        case payment
    }
}

extension OrderTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.items.rawValue {
            return viewModel.basketSection.value!.items.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.items.rawValue {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BasketItemTableViewCell.reuseId,
                for: indexPath
            ) as! BasketItemTableViewCell
            cell.configurate(item: viewModel.basketSection.value!.items[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == Sections.items.rawValue {
            return 100
        }
        return 60
    }
}
