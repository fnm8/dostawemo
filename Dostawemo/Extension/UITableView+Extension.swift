//
//  UITableView+Extension.swift
//  Dostawemo
//
//  Created by fnm8 on 27/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func setEmptyLabel(with text: String){
        let frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)

        DispatchQueue.main.async {
            let label = UILabel(frame: frame)
            label.font = UIFont.systemFont(ofSize: 13)
            label.textAlignment = .center
            label.text = text
            self.tableFooterView = label
        }
    }
    
    func setEmptyFooter(){
        DispatchQueue.main.async {
            let view = UIView()
            self.tableFooterView = view
        }
    }
    
    func removeEmptyLabel(){
        DispatchQueue.main.async {
            self.tableFooterView = nil
        }
    }
    
     func emptyCell(text: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = text
        cell.textLabel?.textColor = .lightGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func registerCell(identifier: String){
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}
