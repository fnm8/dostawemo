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
    
    private let sectionCount = 4
    
    // MARK: - Table View Section
    private let pInfoSection = 0
    private let pTradeSection = 1
    private let pGroupSegmentSection = 2
    private let pDetailSection = 3
    
    //MARK: - Table View Row Section
    private let pInfoPrewRow = 0

    
    private let pTradePriceRow = 0
    private let pTradeBasketButtonRow = 1
    private let addBasketRowHeight: CGFloat = 80
    private let addBasketButtonTitle = "Добавить в корзину"
    
    private let pDetailSegmentRow = 0
    private let pDetailSegmentDetailRow = 1
    
    var viewModel: ProductViewModel!
    var state: GroupProductInfoSegment = .info
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.product.name
        configurateBasketButton()
        registerCell()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
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
        
        tableView.register(
            GroupSegmentProductInfoTableViewCell.nib,
            forCellReuseIdentifier: GroupSegmentProductInfoTableViewCell.reuseId
        )
        
        tableView.register(
            ProductDescriptionTableViewCell.nib,
            forCellReuseIdentifier: ProductDescriptionTableViewCell.reuseId
        )
        
        tableView.register(
            BasketButtonTableViewCell.nib,
            forCellReuseIdentifier: BasketButtonTableViewCell.reuseId
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
        case pInfoSection:          return 1
        case pTradeSection:         return 2
            
        // Segment controll
        case pGroupSegmentSection:  return 1
            
        // Deatail
        case pDetailSection:
            switch state{
                case .info:         return 1
                case .comment:      return 0
                case .question:     return 0
            }
            
        default:                    return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == pInfoSection {
            return getProductInfoPreviewCell(ip: indexPath)
        }
        if indexPath.section == pTradeSection {
            if indexPath.row == pTradePriceRow{
                return getPriceCell(ip: indexPath)
            } else {
                return basketButton(ip: indexPath)
            }
        }
        
        if indexPath.section == pGroupSegmentSection {
            return getSegmentCell(ip: indexPath)
        }
        
        if indexPath.section == pDetailSection {
            switch state {
                case .info:     return getProductDetailCell(ip: indexPath)
                case .comment:  return UITableViewCell()
                case .question: return UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }
    
    // MARK: - Cell
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
    
    private func getSegmentCell(ip: IndexPath) -> GroupSegmentProductInfoTableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupSegmentProductInfoTableViewCell.reuseId,
            for: ip
            ) as! GroupSegmentProductInfoTableViewCell
        cell.segmentState = { [weak self] state in self?.stateDetailChange(state: state) }
        return cell
    }
    
    private func getProductDetailCell(ip: IndexPath) -> ProductDescriptionTableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductDescriptionTableViewCell.reuseId,
            for: ip
            ) as! ProductDescriptionTableViewCell
        cell.configurate(product: viewModel.product)
        return cell
    }
    
    private func basketButton(ip: IndexPath) -> BasketButtonTableViewCell{
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BasketButtonTableViewCell.reuseId,
            for: ip
            ) as! BasketButtonTableViewCell
        cell.basketButton.rx.tap.asDriver()
            .drive(onNext: {
                //TODO: - add tap handle
                print("Add Basket Button Tapped")
            }).disposed(by: disposeBag)
        
        return cell
    }
    
    private func stateDetailChange(state: GroupProductInfoSegment){
        self.state = state
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadSections([self.pDetailSection], with: .fade)
            self.tableView.endUpdates()
        }
        switch state {
        case .info:
            removeEmptyLabel()
        case .comment:
            addEmptyLabel(mess: "Никто не оставлял отзывов")
        case .question:
            addEmptyLabel(mess: "Вопросы о товаре отсутствуют")
        }
    }
    
    private func addEmptyLabel(mess: String){
        let w = tableView.bounds.width
        let h = CGFloat(60)
        let frame = CGRect(x: 0, y: 0, width: w, height: h)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.text = mess
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        tableView.tableFooterView = label
    }
    
    private func removeEmptyLabel(){
        tableView.tableFooterView = nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
