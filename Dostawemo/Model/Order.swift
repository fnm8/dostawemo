//
//  Order.swift
//  Dostawemo
//
//  Created by fnm8 on 20/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import Firebase


class Order: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var purchaseId: String = ""
    @objc dynamic var prepaymentId: String = ""
    @objc dynamic var sberbankPrepaymentId: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var prepayment: Int = 0
    @objc dynamic var totalCost: Double = 0.0
    @objc dynamic var deliveryAddress: String = ""
    @objc dynamic var deliveryType: String = ""
    @objc dynamic var created: Date = Date()
    dynamic var products = List<OrderProduct>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class OrderProduct: Object {
    @objc dynamic var productId: String = ""
    @objc dynamic var productName: String = ""
    @objc dynamic var price: Double = 0.0
    @objc dynamic var color: String = ""
    @objc dynamic var size: String = ""
    @objc dynamic var count: Int = 0
}

class OrderParser{
    
    static func create(document: DocumentSnapshot) -> Order {
        let json = document.data()!
        let order = Order()
        order.id = document.documentID
       
        order.purchaseId = json["purchaseId"] as? String ?? ""
        order.prepaymentId = json["prepaymentId"] as? String ?? ""
        order.sberbankPrepaymentId = json["sberbankPrepaymentId"] as? String ?? ""
        order.status = json["status"] as? String ?? ""
        order.prepayment = json["prepayment"] as? Int ?? 0
        order.totalCost = json["totalCost"] as? Double ?? 0.0
        order.deliveryAddress = json["deliveryAddress"] as? String ?? ""
        order.deliveryType = json["deliveryType"] as? String ?? ""
        if let timestamp = json["created"] as? Timestamp{
            order.created = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        }
        
        if let productJson = json["products"] as? [[String: Any]]{
            productJson.forEach{
                let orderProduct = OrderProduct()
                orderProduct.productId = $0["productId"] as? String ?? ""
                orderProduct.productName = $0["productName"] as? String ?? ""
                orderProduct.count = $0["count"] as? Int ?? 0
                orderProduct.price = $0["price"] as? Double ?? 0.0
                if let options = $0["options"] as? [String: Any]{
                    orderProduct.color = options["color"] as? String ?? ""
                    orderProduct.size = options["size"] as? String ?? ""
                }
                order.products.append(orderProduct)
            }
        }
        return order
    }
}

