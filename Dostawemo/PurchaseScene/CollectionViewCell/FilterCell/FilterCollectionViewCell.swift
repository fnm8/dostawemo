//
//  FilterCollectionViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 25/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.subviews.forEach{
            $0.removeFromSuperview()
        }
    }
    
    func configurate(){
        let frame = CGRect(
            x: 0,
            y: 0,
            width: 50,
            height: scrollView.bounds.height
        )
        let testLabel = UILabel(frame: frame)
        testLabel.text = "filter_1"
        
        let frame1 = CGRect(
            x: 50,
            y: 0,
            width: 50,
            height: scrollView.bounds.height
        )
        let testLabel2 = UILabel(frame: frame1)
        testLabel2.text = "filter_2"
        
        let frame2 = CGRect(
            x: 100,
            y: 0,
            width: 50,
            height: scrollView.bounds.height
        )
        let testLabel3 = UILabel(frame: frame2)
        testLabel3.text = "filter_3"
        
        scrollView.addSubview(testLabel)
        scrollView.addSubview(testLabel2)
        scrollView.addSubview(testLabel3)
    }

}
