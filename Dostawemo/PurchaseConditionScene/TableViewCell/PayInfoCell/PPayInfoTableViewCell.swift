//
//  PPayInfoTableViewCell.swift
//  Dostawemo
//
//  Created by fnm8 on 23/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit

class PPayInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var requriedAmountLabel: UILabel!
    @IBOutlet weak var collectedAmountLabel: UILabel!
    @IBOutlet weak var percentCompletedLabel: UILabel!
    @IBOutlet weak var completedProgressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configurate(purchase: Purchases){
        requriedAmountLabel.text = "\(purchase.requiredAmount)".addRubPostfix()
        collectedAmountLabel.text = "\(purchase.collectedAmount)".addRubPostfix()
        setCompleted(purchase: purchase)
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
        completedProgressView.tintColor = UIColor.color(by: res)
        
    }
}
