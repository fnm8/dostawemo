//
//  ColorAttributeTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 24/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class ColorAttributeTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    var colors: [String] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorCollectionViewCell.nib, forCellWithReuseIdentifier: ColorCollectionViewCell.reuseId)
        
        collectionView.contentInset = sectionInsets
    }
    
    
    func configurate(product: Product){
        colors = Array(product.colors)
        collectionView.reloadData()
    }
}

extension ColorAttributeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        cell.colorLabel.text = colors[indexPath.row]
        cell.colorLabel.backgroundColor = .clear
        cell.colorLabel.textColor = .red
        cell.colorLabel.layer.cornerRadius = cell.colorLabel.bounds.height / 2
        cell.colorLabel.clipsToBounds = true
        cell.configurate()
        return cell
    }
}

extension ColorAttributeTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = colors[indexPath.row].count > 10 ? CGFloat(230) : CGFloat(150)
        let height = collectionView.bounds.height - sectionInsets.top - sectionInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach{ cell in
            DispatchQueue.main.async {
                (cell as! ColorCollectionViewCell).colorLabel.backgroundColor = .clear
                (cell as! ColorCollectionViewCell).colorLabel.textColor = .red
            }
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
        else { return }
        
        DispatchQueue.main.async {
            cell.colorLabel.backgroundColor = .red
            cell.colorLabel.textColor = .white
        }
    }
}
