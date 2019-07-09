//
//  PurchaseTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 21/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import AlamofireImage

class PurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leavesDayLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var complitedProgressView: UIProgressView!
    @IBOutlet weak var membersCounterLabel: UILabel!
    @IBOutlet weak var productCounterLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    @IBOutlet weak var purchaseImageView: UIImageView!
    
    @IBOutlet weak var countryImage1: UIImageView!
    @IBOutlet weak var countryImage2: UIImageView!
    @IBOutlet weak var countryImage3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        countryImage1.image = UIImage(named: "ru")
        countryImage2.image = UIImage(named: "bl")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text?.removeAll()
        leavesDayLabel.text?.removeAll()
        completedLabel.text?.removeAll()
        membersCounterLabel.text?.removeAll()
        productCounterLabel.text?.removeAll()
        statusLabel.text?.removeAll()
        orderCountLabel.text?.removeAll()
        purchaseImageView.af_cancelImageRequest()
        purchaseImageView.image = nil
        let progress = Progress(totalUnitCount: 1)
        progress.completedUnitCount = 0
        complitedProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
    }
//
//    func clearState(){
//
//        clearImageView(imageView: purchaseImageView)
//        let progress = Progress(totalUnitCount: 1)
//        progress.completedUnitCount = 0
//        complitedProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
//    }
    
    func configurate(purchase: Purchases){
        if let url = URL(string: purchase.image){
            purchaseImageView.af_setImage(withURL: url)
        }
        nameLabel.text = purchase.name
        leavesDayLabel.text = "Осталось дней \(purchase.leavesDay)"
        setCompleted(purchase: purchase)
        membersCounterLabel.text = String(purchase.purchaseCount)
        productCounterLabel.text = String(purchase.productsCount)
        statusLabel.text = purchase.status
        orderCountLabel.text = "\(purchase.collectedAmount) сбор"
    }
    
    
    private func setCompleted(purchase: Purchases){
        let progress = Progress(totalUnitCount: Int64(purchase.requiredAmount))
        let perc = purchase.requiredAmount / 100
        let res = purchase.collectedAmount / perc
        
        if purchase.collectedAmount == 0 {
            completedLabel.text = "0%"
            complitedProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
            return
        }
        completedLabel.text = String(res) + "%"
        progress.completedUnitCount = Int64(purchase.collectedAmount)
        complitedProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
        complitedProgressView.tintColor = color(percent: res)
        
    }
    
    private func color(percent: Int) -> UIColor {
        if percent < 30 {
            return .lightGray
        }
        if percent > 30 && percent < 60 {
            return .yellow
        }
        return .green
    }
}
