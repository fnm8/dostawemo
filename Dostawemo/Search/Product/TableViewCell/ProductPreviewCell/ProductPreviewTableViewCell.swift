//
//  ProductPreviewTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 07/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductPreviewTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var favsButton: UIButton!
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControll: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favsButton.setImage(UIImage.favs, for: .normal)
        favsButton.tintColor = .black
        sharedButton.setImage(UIImage.shared, for: .normal)
        sharedButton.tintColor = .red
        contentView.bringSubviewToFront(pageControll)
    }
    
    func configurate(product: Product){
        descriptionLabel.text = product.name
        configurateScrollView(product: product)
        configuratePageControl(product: product)
    }
    
    private func configurateScrollView(product: Product){
        let width = imageScrollView.bounds.width * CGFloat(product.imagesPath.count)
        let height = imageScrollView.bounds.height
        imageScrollView.contentSize = CGSize(width: width, height: height)
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        
        for (index, path) in product.imagesPath.enumerated(){
            let y: CGFloat = CGFloat(0)
            let x: CGFloat = CGFloat(0) + (self.bounds.width - 40) * CGFloat(index)
            let frame = CGRect(
                x: x, y: y,
                width: imageScrollView.bounds.width,
                height: imageScrollView.bounds.height
            )
            let imageView = UIImageView(frame: frame)
            imageView.contentMode = .scaleAspectFit
            if let url = URL(string: path) {
                imageView.af_setImage(withURL: url)
            }
            imageScrollView.addSubview(imageView)
        }
    }
    
    private func configuratePageControl(product: Product){
        if product.imagesPath.isEmpty || product.imagesPath.count == 1 {
            pageControll.isHidden = true
            return
        }
        pageControll.numberOfPages = product.imagesPath.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControll.currentPage = Int(pageNumber)
    }
}
