//
//  PaymentViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 17/07/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import WebKit

class PrePaymentViewController: UIViewController, WKUIDelegate, WKNavigationDelegate  {

    var webView: WKWebView!
    var orderId: String?
    var url: String!
    
    private let viewModel = PrePaymentViewModel()
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString, url.contains("order/success-prepayment"){
            if let orderId = orderId{
                viewModel.removeCartItem(by: orderId)
            }
        }
        self.dismiss(animated: true) {
           app.coordinator.showUserPurchase.onNext(())
        }
    }
}
