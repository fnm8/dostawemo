//
//  PurchasesTableViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 21/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RealmSwift
import RxDataSources
import RxSwift
import RxCocoa

class PurchasesTableViewController: UITableViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    private let purchaseSegue = "ShowPurchaseScene"
    private let disposeBag = DisposeBag()
    private var viewModel: PurchasesViewModel!
    
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionPurchases>(
        configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseTableViewCell.reuseId, for: indexPath) as! PurchaseTableViewCell
            cell.configurate(purchase: item)
            return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        setAppTitle()
        viewModel = PurchasesViewModel(
            segment: segmentControl.rx.value.asDriver()
        )

        tableView.register(
            PurchaseTableViewCell.nib,
            forCellReuseIdentifier: PurchaseTableViewCell.reuseId
        )
        configurateTableView()
    }
    
    private func configurateTableView(){
        
        viewModel.purchases
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in self?.tableView.reloadData()})
            .disposed(by: disposeBag)

        tableView.setEmptyLabel(with: "Закупки не найдены")
    }
    
    private func show(_ purchase: Purchases){
        self.performSegue(withIdentifier: purchaseSegue, sender: purchase)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == purchaseSegue {
            let vc = segue.destination as! UINavigationController
            let purchaseVc = vc.topViewController as! PurchaseCollectionViewController
            let p = sender as! Purchases
            purchaseVc.purchaseId = p.id
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.purchases.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseTableViewCell.reuseId, for: indexPath) as! PurchaseTableViewCell
        cell.configurate(purchase: viewModel.purchases.value[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        show(viewModel.purchases.value[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
