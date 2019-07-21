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
        viewModel = PurchasesViewModel(segment: segmentControl.rx.value.asDriver())
        registerCell()
        cShowUserPurchase()
        configurateTableView()
    }
    
    private func registerCell(){
        tableView.register(
            PurchaseTableViewCell.nib,
            forCellReuseIdentifier: PurchaseTableViewCell.reuseId
        )
    }
    
    private func cShowUserPurchase(){
        app.coordinator.showUserPurchase
            .subscribe(onNext: {[weak self] _ in self?.showUserPurchase()})
            .disposed(by: disposeBag)
    }
    
    private func showUserPurchase(){
        segmentControl.selectedSegmentIndex = 2
        segmentControl.sendActions(for: .valueChanged)
    }
    
    private func configurateTableView(){
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel.purchases
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: {[weak self] ip in
                self?.tableView.deselectRow(at: ip, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Purchases.self).asDriver()
            .withLatestFrom(segmentControl.rx.value.asDriver()){(purchase: $0, index: $1)}
            .drive(onNext: {[weak self] combine in
                print("tap++++")
                if combine.index == 2 {
                    self?.showUserPurchase(purchase: combine.purchase)
                } else {
                    self?.showPurchase(purchase: combine.purchase)
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    private func showPurchase(purchase: Purchases){
        let nav = UIStoryboard(name: "PurchaseScene", bundle: nil)
            .instantiateViewController(withIdentifier: "PurchaseScene") as! UINavigationController
        let vc = nav.topViewController as! PurchaseCollectionViewController
        vc.purchaseId = purchase.id
        self.present(nav, animated: true, completion: nil)
    }

    private func showUserPurchase(purchase: Purchases){
        let nav = UINavigationController()
        let vc = UserPurchaseTableViewController(nibName: nil, bundle: nil)
        vc.purchaseId = purchase.id
        nav.setViewControllers([vc], animated: true)
        self.present(nav, animated: true, completion: nil)
    }
}
