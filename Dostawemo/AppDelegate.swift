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
    let imageCache =  AutoPurgingImageCache ()
    let coordinator = Coordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        cUI()
        cRealm()
        cFirebase()
        showPreloaderView()
        return true
    }
    
    private func cUI(){
        UINavigationBar.appearance().tintColor = UIColor.black
    }
    
    private func cFirebase(){
        FirebaseApp.configure()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
    }
    
    private func showPreloaderView(){
        let nav = UINavigationController()
        let vc = PreloaderViewController(nibName: "PreloaderViewController", bundle: nil)
        nav.setViewControllers([vc], animated: true)
        nav.isNavigationBarHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    private func cRealm(){
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
}




