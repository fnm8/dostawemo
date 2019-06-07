//
//  TopProductsViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 05/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TopProductsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let headerId = "SearchHeader"
    private let disposeBag = DisposeBag()
    
    var basket: UIBarButtonItem!
    var viewModel: TopProductsViewModel!
    
    private let sectionInsets = UIEdgeInsets(top: 8.0, left: 4.0, bottom: 8.0, right: 4.0)
    private let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppTitle()
        viewModel = TopProductsViewModel()
        configurateCollectionView()
        configurateBasketButton()
        
        viewModel.products
            .subscribe(onNext: {[weak self] _ in self?.collectionView.reloadData()})
            .disposed(by: disposeBag)
    }
    
    //MARK: - Configuration collection view
    private func configurateCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            UINib(nibName: "TopProductCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "TopProductCollectionViewCell")
    }
    
    //MARK: - Configuration Basket Bar Button
    private func configurateBasketButton(){
        basket = UIBarButtonItem(image: UIImage.basket, style: .plain, target: nil, action: nil)
        basket.rx.tap.asDriver()
            .drive(onNext: {[weak self] in self?.showBasket()})
            .disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = basket
    }
    
    private func showBasket(){
        BasketSceneTableViewController.show(on: self)
    }
}

extension TopProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopProductCollectionViewCell", for: indexPath) as! TopProductCollectionViewCell
        cell.configurate(product: viewModel.products.value[indexPath.row])
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        return headerView
    }
    
}

extension TopProductsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem  + widthPerItem / 2
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productVc = ProductTableViewController(nibName: nil, bundle: nil)
        productVc.viewModel = ProductViewModel(product: viewModel.products.value[indexPath.row])
        navigationController?.pushViewController(productVc, animated: true)
    }
}

