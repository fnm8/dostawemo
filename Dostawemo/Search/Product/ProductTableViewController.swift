//
//  ProductTableViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 07/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProductTableViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    
    private let sectionCount = 3
    
    // MARK: - Table View Section
    private let pInfoSection = 0
    private let pTradeSection = 1
    private let pDetailSection = 2
    
    //MARK: - Table View Row Section
    private let pInfoPrewRow = 0

    
    private let pTradePriceRow = 0
    private let pTradeBasketButtonRow = 1
    private let addBasketRowHeight: CGFloat = 80
    private let addBasketButtonTitle = "Добавить в корзину"
    
    private let pDetailSegmentRow = 0
    private let pDetailSegmentDetailRow = 1
    
    var viewModel: ProductViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.product.name
        configurateBasketButton()
        registerCell()
        tableView.tableFooterView = UIView()
    }
    
    private func registerCell(){
        tableView.register(
            ProductPreviewTableViewCell.nib,
            forCellReuseIdentifier: ProductPreviewTableViewCell.reuseId
        )
        
        tableView.register(
            PriceTableViewCell.nib,
            forCellReuseIdentifier: PriceTableViewCell.reuseId
        )
    }
    
    private func configurateBasketButton(){
        let image = UIImage.basket
        let basketButton = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        basketButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in self?.showBasket()})
            .disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = basketButton
    }
    
    private func showBasket(){
        BasketSceneTableViewController.show(on: self)
    }
}

extension ProductTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case pInfoSection:      return 1
        case pTradeSection:     return 2
        case pDetailSection:    return 2
        default:                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == pInfoSection {
            return getProductInfoPreviewCell(ip: indexPath)
        }
        if indexPath.section == pTradeSection{
            if indexPath.row == pTradePriceRow{
                return getPriceCell(ip: indexPath)
            } else {
                return addToBasketButtonCell(ip: indexPath)
            }
        }
        return UITableViewCell()
    }
    
    private func getProductInfoPreviewCell(ip: IndexPath) -> ProductPreviewTableViewCell{
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductPreviewTableViewCell.reuseId,
            for: ip
        ) as! ProductPreviewTableViewCell
        cell.configurate(product: viewModel.product)
        return cell
    }
    
    private func getPriceCell(ip: IndexPath) -> PriceTableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PriceTableViewCell.reuseId,
            for: ip
        ) as! PriceTableViewCell
        cell.configurate(product: viewModel.product)
        return cell
    }
    
    private func addToBasketButtonCell(ip: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        let offsetW: CGFloat = 40
        let offsetH: CGFloat = 15
        let width = tableView.bounds.width - offsetW * 2
        let height: CGFloat = 50
        let frame = CGRect(x: offsetW, y: offsetH, width: width, height: height)
        
        let button = UIButton(frame: frame)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle(addBasketButtonTitle, for: .normal)
        button.layer.cornerRadius = height / 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        cell.contentView.addSubview(button)
        
        button.rx.tap.asDriver()
            .drive(onNext: {
                //TODO: - add tap handle
                print("Add Basket Button Tapped")
            }).disposed(by: disposeBag)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case pInfoSection:
            switch indexPath.row {
                case pInfoPrewRow:      return 410
                default:                return 0
            }
            
        case pTradeSection:
            return indexPath.row == pTradePriceRow ? 110 : addBasketRowHeight
            
        default:
            return 0
        }
    }
}
