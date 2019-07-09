//
//  SetProductAttributeViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 03/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SetProductAttributeViewController: UIViewController {
    
    var product: Product!
    var options: ProductOptions!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var close: (()->())?
    var confirm: (()->())?
    
    var rowsCount: Int {
        var counter = 1
        counter += product.sizes.isEmpty ? 0 : 1
        counter += product.colors.isEmpty ? 0 : 1
        return counter
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        container.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        cButton()
        cCloseButton()
        registerCell()
        cConfirmButton()
        
        UIView.animate(withDuration: 0.1) {
            self.containerHeight.constant = CGFloat(90 + self.rowsCount * 80)
            self.loadViewIfNeeded()
        }
        
    }
    
    private func cConfirmButton(){
        confirmButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in self?.confirm?() })
            .disposed(by: disposeBag)
    }
    
    private func cCloseButton(){
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.dismiss(animated: true, completion: {
                    self?.close?()
                })
            }).disposed(by: disposeBag)
    }
    
    private func registerCell(){
        tableView.register(
            CountProductTableViewCell.nib,
            forCellReuseIdentifier: CountProductTableViewCell.reuseId
        )
        
        tableView.register(
            AttributeScrolableTableViewCell.nib,
            forCellReuseIdentifier: AttributeScrolableTableViewCell.reuseId
        )
    }
    
    private func cButton(){
        confirmButton.layer.cornerRadius = confirmButton.bounds.height / 2
    }
    
    private func cView(){
//        let tap = UITapGestureRecognizer()
//        view.isUserInteractionEnabled = true
//
//        tap.rx.event
//            .asDriver()
//            .drive(onNext: {[weak self] _ in
//
//            .disposed(by: disposeBag)
//
//        view.addGestureRecognizer(tap)
    }

}

extension SetProductAttributeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == rowsCount - 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CountProductTableViewCell.reuseId, for: indexPath
            ) as! CountProductTableViewCell
            cell.amount = {[weak self] amount in self?.options.count = amount }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(
                withIdentifier: AttributeScrolableTableViewCell.reuseId, for: indexPath
            ) as! AttributeScrolableTableViewCell
        
        if indexPath.row == 0 && !product.sizes.isEmpty {
            cell.configurate(dataSource: Array(product.sizes), selected: options.size)
            cell.selectedItem = {[weak self] value in self?.options.size = value }
        } else {
            cell.configurate(dataSource: Array(product.colors), selected: options.color)
            cell.selectedItem = {[weak self] value in self?.options.color = value }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


