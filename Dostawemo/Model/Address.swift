//
//  Address.swift
//  Dostawemo
//
//  Created by fnm8 on 20/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers
class Address: Object {
    dynamic var name = ""
    dynamic var city = ""
    dynamic var street = ""
    dynamic var postIndex = ""
}
