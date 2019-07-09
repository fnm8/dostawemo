//
//  CitiesDeliveryPrices.swift
//  Dostawemo
//
//  Created by fnm8 on 20/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class DeliveryPrices: Object {
    
    dynamic var cityId: String = ""
    dynamic var deliveryTypeCourier: Double = 0.0
    dynamic var deliveryTypePVZ: Double = 0.0
}
