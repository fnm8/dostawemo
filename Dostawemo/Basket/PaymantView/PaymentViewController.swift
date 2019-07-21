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
    var url: String!
    
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
        print(webView.url)
        //order/success-prepayment
    }

}
