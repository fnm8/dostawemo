//
//  PreloaderViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 18/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

class PreloaderViewController: UIViewController {

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuth()
    }
    
    private func checkAuth(){
        do {
            let realm = try Realm()
            let auth = realm.objects(AuthCredentials.self).first
            if auth == nil {
                showMain()
                return
            }
            updateAuth(refresh: auth!.refresh)
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    private func updateAuth(refresh: String){
        AuthService.refresh(refresh: refresh)
            .subscribe(onNext:{ [weak self] res in
                print(res)
                if res.error != nil {
                    print(res.error!.localizedDescription)
                    return
                }
                self?.updateAuthCredentials(credentials: res.value!)
            }).disposed(by: disposeBag)
    }
    
    private func updateAuthCredentials(credentials: (cToken: String, aToken: String)){
        do {
            let realm  = try Realm()
            if let auth = realm.objects(AuthCredentials.self).first {
                try realm.write {
                    auth.token = credentials.aToken
                    auth.custom = credentials.cToken
                }
            }
            showMain()
        } catch let e {
            showMain()
            print(e.localizedDescription)
        }
    }
    
    private func showMain(){
        app.coordinator.start.onNext(())
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboardIpad.instantiateViewController(withIdentifier: "Main") as! MainTabViewController
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}
