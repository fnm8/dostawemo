//
//  ProductImagesTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 01/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class ProductImagesTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private var images: [String] = []
    
    var showImage: ((UIImageView)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.contentInset = sectionInsets
        collectionView.register(
            ProductImageCollectionViewCell.nib,
            forCellWithReuseIdentifier: ProductImageCollectionViewCell.reuseId
        )
    }
    
    func configurate(product: Product){
        images = Array(product.imagesPath)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ProductImagesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dump(images.count)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductImageCollectionViewCell.reuseId,
            for: indexPath
        ) as! ProductImageCollectionViewCell
        cell.setImage(path: images[indexPath.row])
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductImageCollectionViewCell,
        let _ = cell.productImageView.image
        else { return }
        showImage?(cell.productImageView)
    }
}
