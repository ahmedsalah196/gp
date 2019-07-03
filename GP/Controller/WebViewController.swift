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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
