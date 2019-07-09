//
//  Purchases.swift
//  Dostawemo
//
//  Created by fnm8 on 20/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import Firebase
import RxDataSources

@objcMembers
class Purchases: Object {
    
    dynamic var id: String = ""
    dynamic var prefix: String = ""
    dynamic var name: String = ""
    dynamic var status: String = ""
    dynamic var producerCity: String = ""
    dynamic var productsCount: Int = 0
    dynamic var purchaseCount: Int = 0
    dynamic var requiredAmount: Int = 0
    dynamic var collectedAmount: Int = 0
    dynamic var startDate: Date = Date()
    dynamic var endDate: Date = Date()
    dynamic var about: String = ""
    
    dynamic var image: String = ""
    
    dynamic var countries = List<String>()
    dynamic var provider = List<String>()
    
    var leavesDay: Int {
        let components = Calendar.current.dateComponents([.day], from: Date(), to: endDate)
        return components.day!
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct SectionPurchases {
    var header: String
    var items: [Purchases]
}

extension SectionPurchases: SectionModelType {
    typealias Item = Purchases
    
    init(original: SectionPurchases, items: [Item]) {
        self = original
        self.items = items
    }
}

class PurchasesSerialize{
    
    static func parse(id: String, data: [String: Any]) -> Purchases {
        
        let json = data
        print(json)
        let purchases = Purchases()
        purchases.id = id
        purchases.prefix = json["prefix"] as? String ?? ""
        purchases.name = json["name"] as? String ?? ""
        purchases.status = json["status"] as? String ?? ""
        purchases.producerCity = json["producerCity"] as? String ?? ""
        purchases.productsCount = json["productsCount"] as? Int ?? 0
        purchases.purchaseCount = json["purchaseCount"] as? Int ?? 0
        purchases.requiredAmount = json["requiredAmount"] as? Int ?? 0
        purchases.requiredAmount = json["requiredAmount"] as? Int ?? 0
        purchases.collectedAmount = json["collectedAmount"] as? Int ?? 0
        
        if let timestamp = json["startDate"] as? Timestamp{
            purchases.startDate = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        }
        
        if let timestamp = json["endDate"] as? Timestamp{
            purchases.endDate = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        }
        purchases.about = json["about"] as? String ?? ""
        purchases.image = json["image"] as? String ?? ""
        
        let countries = json["countries"] as? [String] ?? []
        let countriesList = List<String>()
        countriesList.append(objectsIn: countries)
        purchases.countries = countriesList
        
        let provider = json["provider"] as? [String] ?? []
        let providerList = List<String>()
        providerList.append(objectsIn: provider)
        purchases.provider = providerList
        
        return purchases
    }
}
