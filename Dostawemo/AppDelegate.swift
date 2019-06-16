//
//  AppDelegate.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 04/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var basket: Basket!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        basket = Basket()
        
//        Auth.auth().signInAnonymously() { (authResult, error) in
//            let user = authResult?.user
//            let isAnonymous = user?.isAnonymous  // true
//            let uid = user?.uid
//
//            dump(user?.uid)
//            print(error)
//        }
        
        Auth.auth().signIn(withCustomToken: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTU2MDQxODIwMywiZXhwIjoxNTYwNDIxODAzLCJpc3MiOiJkb3N0YXdlbW8tM2MwYTFAYXBwc3BvdC5nc2VydmljZWFjY291bnQuY29tIiwic3ViIjoiZG9zdGF3ZW1vLTNjMGExQGFwcHNwb3QuZ3NlcnZpY2VhY2NvdW50LmNvbSIsInVpZCI6IllOcTJWcnZzWmRPRVJZblJsbG05dVFJd3dDZjEifQ.KqTokEoOFILdDEHkOzpDT_Hy_vtFzzGyGWtl00fHm1l8EO6_U9aBesiIH2FtaZR8ItMghOl-WBaoVLSClIgmkadUVvZGgXi_HT-E9HSzpedAMdpi0JKTtW3xRvZVSzYVB6FCxZeBSvjN9i1sv9TXGTP8ViIrTL3eozSFxoJrRuxX3graJxWUbu3hmUbm_EvNE4vpFGrVJEG_nFi6bBM_fuT-qsrmaDh1xxu1Zw9jsoZePLToR3jT26QFFlz2CpTbEqHUbqW9JUTZeRJAAX15rHunLlMfV7M9tNzh4HsrH0tR_BJYcC9VdXNWudQP8wdQ7MZSmQ6WemVsRNfZvYGTWQ") { (user, error) in
            dump(user?.user.uid)
            dump(error)
        }
        
        return true
    }
}

