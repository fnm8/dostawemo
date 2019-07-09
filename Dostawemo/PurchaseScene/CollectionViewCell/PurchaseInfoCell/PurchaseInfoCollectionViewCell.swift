//
//  PurchaseInfoCollectionViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 25/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class PurchaseInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var purchaseNameLabel: UILabel!
    @IBOutlet weak var orderCounterLabel: UILabel!
    @IBOutlet weak var leavesDayLabel: UILabel!
    @IBOutlet weak var percentCompletedLabel: UILabel!
    @IBOutlet weak var completedProgressView: UIProgressView!
    @IBOutlet weak var membersCounterLabel: UILabel!
    @IBOutlet weak var productCounterLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configurate(purchase: Purchases){
        purchaseNameLabel.text = purchase.name
        leavesDayLabel.text = "Осталось дней \(purchase.leavesDay)"
        setCompleted(purchase: purchase)
        membersCounterLabel.text = String(purchase.purchaseCount)
        productCounterLabel.text = String(purchase.productsCount)
        statusLabel.text = purchase.status
        orderCounterLabel.text = "\(purchase.collectedAmount) сбор"
    }

    private func setCompleted(purchase: Purchases){
        let progress = Progress(totalUnitCount: Int64(purchase.requiredAmount))
        let perc = purchase.requiredAmount / 100
        let res = purchase.collectedAmount / perc
        
        if purchase.collectedAmount == 0 {
            percentCompletedLabel.text = "0%"
            completedProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
            return
        }
        percentCompletedLabel.text = String(res) + "%"
        progress.completedUnitCount = Int64(purchase.collectedAmount)
        completedProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
        completedProgressView.tintColor = color(percent: res)
        
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
