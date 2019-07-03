//
//  CommoditiesTabBarController.swift
//  GP
//
//  Created by Ahmed Salah on 5/31/19.
//  Copyright © 2019 Ahmed Salah. All rights reserved.
//

import UIKit

class CommoditiesTabBarController: UITabBarController {
    var curCommodity = Commodity.sharedinstance
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
