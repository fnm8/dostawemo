//
//  Auth.swift
//  Dostawemo
//
//  Created by fnm8 on 18/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class AuthCredentials: Object {
    dynamic var custom: String = ""
    dynamic var token: String = ""
    dynamic var refresh: String = ""
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
