//
//  CommodityPrices.swift
//  GP
//
//  Created by Ahmed Salah on 7/4/19.
//  Copyright © 2019 Ahmed Salah. All rights reserved.
//

import UIKit

class CommodityTechnicalIndicatores {
    var dataArray:[Double] = [Double]()
    var extraArray:[Double]?
    init(values:[Double]) {
        dataArray = values
    }
    func extraData(values:[Double]){
        extraArray = values
    }
}
