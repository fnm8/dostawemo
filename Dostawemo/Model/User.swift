//
//  User.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 13/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

@objcMembers
class User: Object {
    dynamic var uid: String = ""
    dynamic var name: String = ""
    dynamic var lastName: String = ""
    dynamic var city: String = ""
    dynamic var birthday: Date = Date()
    dynamic var phoneNumber: String = ""
    dynamic var hobby = List<String>()
    dynamic var orderList = List<String>()
    dynamic var photo: String = ""
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}

class UserParser {
    
    static func create(document: DocumentSnapshot) -> User {
        let json = document.data()!
        let user = User()
        user.uid = document.documentID
        user.name = json["firstName"] as? String ?? ""
        user.lastName = json["lastName"] as? String ?? ""
        user.phoneNumber = json["phoneNumber"] as? String ?? ""
        user.photo = json["photo"] as? String ?? ""
        let orderListArr = json["orderList"] as? [String] ?? []
        let orderList = List<String>()
        orderList.append(objectsIn: orderListArr)
        user.orderList = orderList
        
        if let timestamp = json["birthday"] as? Timestamp{
            user.birthday = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        }
        return user
    }
}
