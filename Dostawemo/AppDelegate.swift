//
//  AppDelegate.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 04/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import Firebase
import Realm
import RealmSwift
import AlamofireImage
import FirebaseFirestore

var app: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var user = User()
    var imagesHash: [String: UIImage] = [:]
    
    var auth: AuthCredentials?
    var loader: DataLoader!
    
    let imageCache =  AutoPurgingImageCache ()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor.black
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        
        updateScheme()
        
        auth = try? Realm().objects(AuthCredentials.self).first
        
        FirebaseApp.configure()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        loader = DataLoader()
        
////        Auth.auth().signInAnonymously() { (authResult, error) in
////            let user = authResult?.user
////            let isAnonymous = user?.isAnonymous  // true
////            let uid = user?.uid
////
////            dump(user?.uid)
////            print(error)
////        }

//        Auth.auth().signIn(withCustomToken: "yJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTU2MjU3NzMwOCwiZXhwIjoxNTYyNTgwOTA4LCJpc3MiOiJkb3N0YXdlbW8tM2MwYTFAYXBwc3BvdC5nc2VydmljZWFjY291bnQuY29tIiwic3ViIjoiZG9zdGF3ZW1vLTNjMGExQGFwcHNwb3QuZ3NlcnZpY2VhY2NvdW50LmNvbSIsInVpZCI6ImQ5ZGJjNmU5LTIxNTgtNDdlNi1hMzFjLTk4ZTFkOTQzODAyNiJ9.D7wnmClGUODzNQbIBgi6eUx43n6QfJ7ZDGEZPINQeOd4ETMoNEgxV1ZNNhp_vGK3S6djZBKZvZDcv8_S5so1-nEBFKEVHoENOgHFfysLs2TzNo_64Sf2IPdvpMyLcurG-XhrjvxDwZRkjqMo2gmiSJNEms8JiMAbMbDYk6H0RbpjrORYdBEs2Og9WQFfumWVbhz_W-_Rja3lZa1OcHjaR6TVQExvt3a2Bsr7sRjCldK5ntzWQ6Mg2KcArDgATexYcZzDu9p5lt24y2TFCJlkLbbE6lbt5VLtjEqSXT1pZWXqiwpwcE58fUFw2WuTPU4bwj3gGvPd-Vw9zQMPDXIMOQ") { (user, error) in
//            dump(user?.user.uid)
//            dump(error)
//        }
        

        
        return true
    }
    
    private func updateScheme(){
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}




