//
//  ProductPreviewTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 07/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class ProductPreviewTableViewCell: UITableViewCell {
    
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
    }
    
    func configurate(product: Product){
        dump(product)
        descriptionLabel.text = product.name
        configurateScrollView(product: product)
    }
    
    private func configurateScrollView(product: Product){
        let width = imageScrollView.bounds.width * CGFloat(product.images.count)
        let height = imageScrollView.bounds.height
        imageScrollView.contentSize = CGSize(width: width, height: height)
        imageScrollView.isPagingEnabled = true
        
        product.images.forEach{
            let frame = self.imageScrollView.bounds
            let imageView = UIImageView(frame: frame)
            self.imageScrollView.addSubview(imageView)
            self.loadImage(path: $0, imageView: imageView)
        }
    }
    
    private func loadImage(path: String, imageView: UIImageView){
        print(path)
        if let url = URL( string: path) {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf:url) {
                    DispatchQueue.main.async {
                        imageView.image = UIImage( data:data)
//                        self.activity?.removeFromSuperview()
//                        self.activity = nil
                    }
                }
            }
        }
    }
}
