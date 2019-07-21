//
//  OrderViewModel.swift
//  Dostawemo
//
//  Created by fnm8 on 09/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class OrderViewModel {
    
    private let disposeBag = DisposeBag()
    
    var openEditProfile = PublishSubject<()>()
    let openPayUrl = PublishSubject<String>()
    var cartItem = BehaviorRelay<CartItem?>(value: nil)
    
    init(purchaseId: String){
        cBasketItem(purchaseId: purchaseId)
    }
    
    private func cBasketItem(purchaseId: String){
        do {
            let realm = try Realm()
            let cartItemObj = realm.objects(CartItem.self)
                .filter(NSPredicate(format: "purnaseId = %@", purchaseId))
                .first
            
            if cartItemObj != nil {
                if cartItemObj!.orderId.isEmpty {
                    setOrderId(cartItem: cartItemObj!)
                } else {
                    cartItem.accept(cartItemObj)
                }
            }

        } catch  {
            print("Error get purchase by id")
        }
    }
    
    private func setOrderId(cartItem: CartItem){
        let orderIdResult = OrderService
            .getOrderId()
            .share()
        
        orderIdResult.filter{$0.value != nil}
            .map{$0.value!}
            .subscribe(onNext: {[weak self] id in
                self?.saveOrderId(orderId: id, cartItemId: cartItem.purnaseId)
            }).disposed(by: disposeBag)
    }
    
    private func saveOrderId(orderId: String, cartItemId: String){
        do {
            let realm = try Realm()
            let cartItemObj = realm.objects(CartItem.self)
                .filter(NSPredicate(format: "purnaseId = %@", cartItemId))
                .first
            
            if cartItemObj != nil {
                try realm.write {
                    cartItemObj!.orderId = orderId
                }
                cartItem.accept(cartItemObj)
            }
            
        } catch  {
            print("Error get purchase by id")
        }
    }
    
    func createOrder(){
        do {
            let realm = try Realm()
            let auth = realm.objects(AuthCredentials.self).first
            if auth == nil {
                openEditProfile.onNext(())
            } else {
                prePayment()
            }
            
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    private func prePayment(){
        let auth = try? Realm().objects(AuthCredentials.self).first
        
        let createOrderResult = cartItem
            .map{$0!}
            
            .map{ combine -> [String: Any] in
                var params: [String: Any] = [:]
                params["orderId"] = combine.orderId
                params["purchaseId"] = combine.purnaseId
                params["purchaseName"] = combine.purchaseName
                params["idToken"] = auth?.token ?? ""
                var items: [[String: Any]] = []
                combine.products.forEach{
                    items.append($0.productJson)
                }
                params["deliveryType"] = "mail"
                params["deliveryAddress"] = "gafda"
                params["totalCost"] = combine.totalPrice
                params["products"] = items
                return params
            }.flatMapFirst{ OrderService.createOrder(params: $0)}
            .share()
        
        createOrderResult
            .filter{$0.value != nil}
            .map{$0.value!}
            .subscribe(onNext: { [weak self] url in self?.openPayUrl.onNext(url) })
            .disposed(by: disposeBag)
        
        createOrderResult
            .filter{$0.error != nil}
            .map{$0.error!}
            .subscribe(onNext: { print($0.localizedDescription) })
            .disposed(by: disposeBag)
    }
}
