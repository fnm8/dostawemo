//
//  Coordinator.swift
//  Dostawemo
//
//  Created by fnm8 on 19/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import RealmSwift

class Coordinator {
    
    var userIsLogin: Bool {
        do {
            let realm = try Realm()
            let auth = realm.objects(AuthCredentials.self).first
            return auth != nil
        } catch let e {
            print(e.localizedDescription)
            return false
        }
    }
    
    let start = PublishSubject<()>()
    let logout = PublishSubject<()>()
    let showUserPurchase = PublishSubject<()>()
    
    private let disposeBag = DisposeBag()
    private let refreshPurchase = PublishSubject<()>()
    private let refreshProducts = PublishSubject<()>()
    let refreshUserData = PublishSubject<()>()
    
    private let productTableName = "products"
    private let purchaseTableName = "purchases"
    private let ordersTableName = "orders"
    private let featuredFilter = true
    
    init(){
        startLoadData()
        cPurchase()
        cUser()
    }
    
    private func startLoadData(){
        start.subscribe(onNext: {[weak self] in
            self?.loadPurchase()
            self?.loadProducts()
            self?.signIn()
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Purchase
    func cPurchase(){
        refreshPurchase
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] in self?.loadPurchase()})
            .disposed(by: disposeBag)
    }
    
    func loadPurchase(){
        let db = Firestore.firestore()
        db.collection(purchaseTableName).addSnapshotListener {[weak self] snap, error in
            if let err = error {
                print("Error updatePurchase: \(err)")
                self?.refreshPurchase.onNext(())
                return
            }
            var purchases: [Purchases] = []
            for document in snap!.documents {
                purchases.append(PurchasesSerialize.create(id: document.documentID, data: document.data()))
            }
            self?.savePurchases(purchases)
        }
    }
    
    private func savePurchases(_ purchases: [Purchases]){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(purchases, update: .all)
            }
        } catch let e {
            print("Error save documents: \(e.localizedDescription)")
            refreshPurchase.onNext(())
            return
        }
    }
    
    // MARK: - Top Product
    func cProducts(){
        refreshProducts
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] in self?.loadProducts()})
            .disposed(by: disposeBag)
    }
    
    func loadProducts(){
        let db = Firestore.firestore()
        db.collection(productTableName).whereField("featured", isEqualTo: featuredFilter)
            .addSnapshotListener() { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err.localizedDescription)")
                    self?.refreshProducts.onNext(())
                    return
                }
                var products: [Product] = []
                for document in querySnapshot!.documents {
                    products.append(ProductSerialize.create(data: document))
                }
                self?.saveProducts(products)
        }
    }
    
    private func saveProducts(_ products: [Product]){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(products, update: .all)
            }
        } catch let e {
            print("Error save documents: \(e.localizedDescription)")
            refreshProducts.onNext(())
            return
        }
    }
    
    //MARK: - User
    
    private func cUser(){
        refreshUserData
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] in self?.signIn()})
            .disposed(by: disposeBag)
        
        logout
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] in self?.logoutUser()})
            .disposed(by: disposeBag)
    }
    
    
    private func signIn(){
        do {
            let realm = try Realm()
            let auth = realm.objects(AuthCredentials.self).first
            if auth == nil {
                return
            }
            Auth.auth().signIn(withCustomToken: auth!.custom) {[weak self] (user, error) in
                if  error != nil {
                    print(error!.localizedDescription)
                    return
                }
                self?.updateUserData(by: user!.user.uid)
            }
            
        } catch let e {
            print(e.localizedDescription)
            refreshUserData.onNext(())
        }
    }
    
    private func updateUserData(by uid: String){
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid).addSnapshotListener {[weak self] document, error in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                self?.saveUserData(document: document!)
        }
    }
    
    private func saveUserData(document: DocumentSnapshot){
        let user = UserParser.create(document: document)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(user, update: .all)
            }
            loadOrders(user: user)
        } catch let e {
            print(e.localizedDescription)
            
        }
    }
    
    private func logoutUser(){
        do{
            let realm = try Realm()
            let user = realm.objects(User.self)
            let auth = realm.objects(AuthCredentials.self)
            try realm.write {
                realm.delete(user)
                realm.delete(auth)
            }
            
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    //MARK: - Orders
    private func loadOrders(user: User){
        let db = Firestore.firestore()//userId
        db.collection(ordersTableName)
            .whereField("userId", isEqualTo: user.uid)
            .addSnapshotListener {[weak self] document, error in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                var orders: [Order] = []
                document!.documents.forEach{
                    let order = OrderParser.create(document: $0)
                    orders.append(order)
                    print($0.documentID)
                    print($0.data())
                    print("================")
                }
                self?.saveUserOrders(orders: orders)
        }
    }
    
    private func saveUserOrders(orders: [Order]){
        do{
            let realm = try Realm()
            
            let ordersOld = realm.objects(Order.self)
            let products = realm.objects(OrderProduct.self)
            
            try realm.write {
                realm.delete(ordersOld)
                realm.delete(products)
                realm.add(orders)
            }
            
        } catch let e {
            print("Error save user orders:")
            print(e.localizedDescription)
        }
    }
}
