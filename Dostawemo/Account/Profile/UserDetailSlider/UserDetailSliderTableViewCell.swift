//
//  UserDetailSliderTableViewCell.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 13/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class UserDetailSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configurate(){
        //contentView.backgroundColor = .red
        
        let w = UIScreen.main.bounds.width
        let h = contentView.frame.height
        
        scrollView.contentSize = CGSize(
            width: w * 2,
            height: h
        )
        scrollView.isPagingEnabled = true
//        
////        let frame = CGRect(x: 0, y: 0, width: w, height: h)
////        let firstView = FirstDetailView(frame: frame)
//        //firstView.backgroundColor = UIColor.green
//        
//        let frame2 = CGRect(x: w, y: 0, width: w, height: h)
//        let secondView = SecondDetailView(frame: frame2)
//        //        secondView.backgroundColor = .blue
//        //
//        //scrollView.addSubview(firstView)
//        scrollView.addSubview(secondView)
    }
    

    
}
