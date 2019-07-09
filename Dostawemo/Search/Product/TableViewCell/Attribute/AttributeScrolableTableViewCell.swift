//
//  AttributeScrolableTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 30/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class AttributeScrolableTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: [String] = []
    private var selectedSource: String = ""
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 8.0, bottom: 10.0, right: 8.0)
    
    var selectedItem: ((String)->())?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataSource.removeAll()
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = sectionInsets
        collectionView.register(
            AttributeCollectionViewCell.nib,
            forCellWithReuseIdentifier: AttributeCollectionViewCell.reuseId
        )
    }
    
    func configurate(dataSource: [String], selected: String){
        self.dataSource = dataSource
        self.selectedSource = selected
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
}

extension AttributeScrolableTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AttributeCollectionViewCell.reuseId,
            for: indexPath) as! AttributeCollectionViewCell
        let name = dataSource[indexPath.row]
        cell.attributeNameCell.text = name
        cell.attributeNameCell.clipsToBounds = true
        cell.contentView.layer.cornerRadius = 20
        cell.attributeNameCell.textColor = selectedSource != name ? .red : .white
        cell.contentView.backgroundColor = selectedSource != name ? .white : .red
        return cell
    }
}

extension AttributeScrolableTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        label.text = dataSource[indexPath.row]
        var  width = label.intrinsicContentSize.width
        width = width < 50 ? 50 : width + 10
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.visibleCells.forEach{ cell in
            if let c = cell as? AttributeCollectionViewCell{
                DispatchQueue.main.async {
                    c.attributeNameCell.textColor = .red
                    c.contentView.backgroundColor = .white
                }
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? AttributeCollectionViewCell {
            DispatchQueue.main.async {
                cell.attributeNameCell.textColor = .white
                cell.contentView.backgroundColor = .red
            }
        }
        
        selectedItem?(dataSource[indexPath.row])
    }
}
