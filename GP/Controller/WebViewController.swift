//
//  WebViewController.swift
//  GP
//
//  Created by Ahmed Salah on 6/26/19.
//  Copyright © 2019 Ahmed Salah. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    let webview = WKWebView()
    var urlstring: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func loadView() {
        self.view = webview
    }
    override func viewWillAppear(_ animated: Bool) {
        
        webview.load(urlstring)
    }
    
}

extension WKWebView {
    func load(_ urlString: String){
        guard let url = URL(string: urlString) else {
            print("not valid url!!")
            return
        }
        let request = URLRequest(url: url)
        load(request)
    }
}
