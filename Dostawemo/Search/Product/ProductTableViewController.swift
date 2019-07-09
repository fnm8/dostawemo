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
    
    private let sectionCount = 5
    
    private let productSection = 0
    private let imagesRow = 0
    private let nameRow = 1
    private let priceRow = 2
    
    private let productSizeSection = 1
    private let productColorSection = 2
    private let addBasketSection = 3
    private let aboutSection = 4

    private let addBasketButtonTitle = "Добавить в корзину"
    
    
    
    var viewModel: ProductViewModel!
    var state: GroupProductInfoSegment = .info
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.product.name
        configurateBasketButton()
        cSuccessAddToBasket()
        registerCell()
        tableView.rowHeight = 80
        tableView.tableFooterView = getFooter()
    }
    
    private func cSuccessAddToBasket(){
        viewModel.successAddToBusket
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {[weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func registerCell(){
        tableView.register(
            ProductImagesTableViewCell.nib,
            forCellReuseIdentifier: ProductImagesTableViewCell.reuseId
        )
        
        tableView.register(
            ProductPreviewTableViewCell.nib,
            forCellReuseIdentifier: ProductPreviewTableViewCell.reuseId
        )
        
        tableView.register(
            PriceTableViewCell.nib,
            forCellReuseIdentifier: PriceTableViewCell.reuseId
        )
        
        tableView.register(
            ProductDescriptionTableViewCell.nib,
            forCellReuseIdentifier: ProductDescriptionTableViewCell.reuseId
        )
        
        tableView.register(
            BasketButtonTableViewCell.nib,
            forCellReuseIdentifier: BasketButtonTableViewCell.reuseId
        )
        
        tableView.register(
            ColorAttributeTableViewCell.nib,
            forCellReuseIdentifier: ColorAttributeTableViewCell.reuseId
        )
        
        tableView.register(
            SizeAttributeTableViewCell.nib,
            forCellReuseIdentifier: SizeAttributeTableViewCell.reuseId
        )
        
        tableView.register(
            AttributeScrolableTableViewCell.nib,
            forCellReuseIdentifier: AttributeScrolableTableViewCell.reuseId
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
        case productSection:        return 3
        case productSizeSection:    return !viewModel.product.sizes.isEmpty ? 1 : 0
        case productColorSection:   return !viewModel.product.colors.isEmpty ? 1 : 0
        case addBasketSection:      return 1
        case aboutSection:          return 1
        default:                    return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == productSection {
            switch indexPath.row {
            case imagesRow:
                return getImagesCell(ip: indexPath)
                
            case nameRow:
                let cell = UITableViewCell()
                cell.textLabel?.text = viewModel.product.name
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
                return cell
                
            case priceRow:
                return getPriceCell(ip: indexPath)
                
            default:        return UITableViewCell()
            }
        }

        if indexPath.section == productColorSection {
            return colorAttributeCell(ip: indexPath)
        }

        if indexPath.section == productSizeSection {
            return sizesAttributeCell(ip: indexPath)
        }
        
        if indexPath.section == addBasketSection {
            return getBasketButton(ip: indexPath)
        }
        
        if indexPath.section == aboutSection {
            switch state{
            case .info:
                return getProductDetailCell(ip: indexPath)
            case .comment:
                return tableView.emptyCell(text: "Никто не оставлял отзывов")
            case .question:
                return tableView.emptyCell(text: "Вопросы о товаре отсутствуют")
            }
        }
        
        return UITableViewCell()
    }
    
    // MARK: - Images Cell
    private func getImagesCell(ip: IndexPath) -> ProductImagesTableViewCell{
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductImagesTableViewCell.reuseId,
            for: ip
            ) as! ProductImagesTableViewCell
        cell.configurate(product: viewModel.product)
        cell.backgroundColor = .yellow
        return cell
    }
    
    private func sizesAttributeCell(ip: IndexPath) -> AttributeScrolableTableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AttributeScrolableTableViewCell.reuseId,
            for: ip
            ) as! AttributeScrolableTableViewCell
        cell.configurate(dataSource: Array(viewModel.product.sizes), selected: viewModel.options.size)
        cell.selectedItem = {[weak self] item in
            self?.viewModel.options.size = item
            print("Size selected: \(item)")
        }
        return cell
    }
    
    private func colorAttributeCell(ip: IndexPath) -> AttributeScrolableTableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AttributeScrolableTableViewCell.reuseId,
            for: ip
            ) as! AttributeScrolableTableViewCell
        cell.configurate(dataSource: Array(viewModel.product.colors), selected: viewModel.options.color)
        cell.selectedItem = {[weak self] item in
            self?.viewModel.options.color = item
            print("Color selected: \(item)")
        }
        return cell
    }
    
    private func getProducSegmentHeader() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        let view = UIView(frame: frame)
        let about = "О товаре"
        let comment = "Отзывы"
        let question = "Вопросы"
        let segment = UISegmentedControl(items: [about, comment, question])
        segment.frame = CGRect(x: 16, y: 7, width: tableView.bounds.width - 32, height: 30)
        segment.tintColor = .red
        segment.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = state.index
        view.addSubview(segment)
        return view
    }
    
    private func getFooter() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        let view = UIView(frame: frame)
        return view
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
       selectedAbout(index: sender.selectedSegmentIndex)
    }
    
    private func selectedAbout(index: Int){
        switch index {
        case 0:
            self.state = .info
        case 1:
            self.state = .comment
            
        case 2:
            self.state = .question
            
        default:
            break
        }
        reloadAbout()
    }
    
    private func reloadAbout(){
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            let set = IndexSet(integer: self.aboutSection)
            self.tableView.reloadSections(set, with: .fade)
            //self.tableView.reloadSections([self.aboutSection], animationStyle: .none)
            self.tableView.endUpdates()
        }
    }
    
    private func getPriceCell(ip: IndexPath) -> PriceTableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PriceTableViewCell.reuseId,
            for: ip
        ) as! PriceTableViewCell
        cell.configurate(product: viewModel.product)
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
    
    private func getBasketButton(ip: IndexPath) -> BasketButtonTableViewCell{
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BasketButtonTableViewCell.reuseId,
            for: ip
            ) as! BasketButtonTableViewCell
        
        cell.addBasket = {[weak self] in self?.showSetAttributeView() }
        return cell
    }
    
    private func showSetAttributeView(){
        let vc = SetProductAttributeViewController(nibName: "SetProductAttributeViewController", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.product = viewModel.product
        vc.options = viewModel.options
        vc.close = {[weak self] in
            self?.tableView.beginUpdates()
            self?.tableView
                .reloadSections([self!.productSizeSection, self!.productColorSection], animationStyle: .none)
            self?.tableView.endUpdates()
        }
        vc.confirm = {[weak self] in
            self?.viewModel.addToBusket()
        }
        self.present(vc, animated: true, completion: nil)
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
        if indexPath.section == productSection {
            switch indexPath.row {
                case imagesRow: return CGSize.aspectRatioHeight(by: tableView.bounds.width)
                case nameRow:   return 44
                case priceRow:  return 90
                case aboutSection: return UITableView.automaticDimension
                default:    return 0
            }
        }
        if indexPath.section == productColorSection || indexPath.section == productSizeSection {
            return 80
        }
        
        if indexPath.section == addBasketSection {
            return 70
        }
        
        if indexPath.section == aboutSection {
            return UITableView.automaticDimension
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == aboutSection{
            return getProducSegmentHeader()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == aboutSection{
            return 44
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dump(indexPath)
    }
}
