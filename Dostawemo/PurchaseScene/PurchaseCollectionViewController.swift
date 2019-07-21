//
//  PurchaseCollectionViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 25/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PurchaseCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var closeBarButton: UIBarButtonItem!
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    private let disposeBag = DisposeBag()
    
    // section
    private let titleSection = 0
    private let conditionRow = 0
    //private let filterRow = 1
    private let imageRow = 1
    private let infoRow = 2
    
    private let productSection = 1
    
    var purchaseId: String!
    var viewModel: PurchaseSceneViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = sectionInsets
        registerCell()
        configurateCloseButton()
        
        viewModel = PurchaseSceneViewModel(purchaseId: purchaseId)
        
        viewModel.purchase
            .filter{$0 != nil}
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] p in
                self?.collectionView.reloadData()
                self?.navigationItem.title = p?.name
            }).disposed(by: disposeBag)
        
        viewModel.products
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.collectionView.reloadSections([1])
                
            })
            .disposed(by: disposeBag)
    }
    
    private func registerCell(){
        collectionView.register(
            PurchaseConditionCollectionViewCell.nib,
            forCellWithReuseIdentifier: PurchaseConditionCollectionViewCell.reuseId
        )
        
        collectionView.register(
            FilterCollectionViewCell.nib,
            forCellWithReuseIdentifier: FilterCollectionViewCell.reuseId
        )
        
        collectionView.register(
            PurchaseImageCollectionViewCell.nib,
            forCellWithReuseIdentifier: PurchaseImageCollectionViewCell.reuseId
        )
        
        collectionView.register(
            PurchaseInfoCollectionViewCell.nib,
            forCellWithReuseIdentifier: PurchaseInfoCollectionViewCell.reuseId
        )
        collectionView.register(
            TopProductCollectionViewCell.nib,
            forCellWithReuseIdentifier: TopProductCollectionViewCell.reuseId
        )
    }
    
    private func configurateCloseButton(){
        closeBarButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] _ in self?.dismiss(animated: true, completion: nil)})
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("Deinit PurchaseCollectionViewController")
    }
}

extension PurchaseCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.purchase.value == nil {
            return 0
        }
        return section == titleSection ? 3 : viewModel.products.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == titleSection {
            if indexPath.row == conditionRow{
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PurchaseConditionCollectionViewCell.reuseId,
                    for: indexPath
                ) as! PurchaseConditionCollectionViewCell
                return cell
            }
            
//            if indexPath.row == filterRow {
//                let cell = collectionView.dequeueReusableCell(
//                    withReuseIdentifier: FilterCollectionViewCell.reuseId,
//                    for: indexPath
//                ) as! FilterCollectionViewCell
//                cell.configurate()
//                return cell
//            }
            if indexPath.row == imageRow {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PurchaseImageCollectionViewCell.reuseId,
                    for: indexPath
                ) as! PurchaseImageCollectionViewCell
                cell.configurate(purchase: viewModel.purchase.value!)
                return cell
            }
            
            if indexPath.row == infoRow {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PurchaseInfoCollectionViewCell.reuseId,
                    for: indexPath
                    ) as! PurchaseInfoCollectionViewCell
                cell.configurate(purchase: viewModel.purchase.value!)
                return cell
            }
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TopProductCollectionViewCell.reuseId,
            for: indexPath
            ) as! TopProductCollectionViewCell
        cell.configurate(product: viewModel.products.value[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == titleSection && indexPath.row == conditionRow {
            let vc = PurchaseConditionTableViewController(nibName: nil, bundle: nil)
            vc.purchases = viewModel.purchase.value!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == productSection {
            let vc = ProductTableViewController(nibName: nil, bundle: nil)
            vc.viewModel = ProductViewModel(product: viewModel.products.value[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PurchaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return conditionCellSize()
        switch indexPath.section {
        case titleSection:
            switch indexPath.row{
                case conditionRow:  return conditionCellSize()
               // case filterRow:     return filterCellSize()
                case imageRow:      return imageCellSize()
                case infoRow:       return infoSize()
                default:            return CGSize()
            }
            
        case productSection:
            return productSize()
            
        default:
            return CGSize()
        }
    }

    private func conditionCellSize() -> CGSize {
        return CGSize(width: collectionView.bounds.width - sectionInsets.left * 2, height: 44)
    }
    
    private func filterCellSize() -> CGSize {
        return CGSize(width: collectionView.bounds.width - sectionInsets.left * 2, height: 44)
    }
    
    private func imageCellSize() -> CGSize {
        let width = collectionView.bounds.width - sectionInsets.left * 2
        let part = width / 4
        let height = part * 3
        return CGSize(width: width, height: height)
    }
    
    private func infoSize() -> CGSize {
        return CGSize(width: collectionView.bounds.width - sectionInsets.left * 2, height: 180)
    }
    
    private func productSize() -> CGSize {
        let width = (collectionView.bounds.width / 2) - sectionInsets.left * 2
        let height = width * 2 - sectionInsets.top * 2
        return CGSize(width: width, height: height)
    }
}

