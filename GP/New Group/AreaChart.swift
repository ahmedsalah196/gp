//
//  AreaChartViewController.swift
//  GP
//
//  Created by Ahmed Salah on 6/28/19.
//  Copyright © 2019 Ahmed Salah. All rights reserved.
//

import UIKit
import SwiftChart

class AreaChart{

    fileprivate var marginConstant: CGFloat!
    typealias chartPoint = (x:Double , y: Double)
    func initializeChart(chart: Chart,
                         prices xs: [Double],
                         fit ys: [Double]) {
        chart.removeAllSeries()
        var serieData: [chartPoint] = []
        var labels: [Double] = []
        var ylabels: [Double] = []
        serieData = Array(zip(xs, ys))
        let step = (xs.last! - xs.first!)/5
        let ystep = (ys.last! - ys.first!)/5
        for i in 0...5 {
            labels.append(xs.first! + step * Double(i))
            ylabels.append(ys.first! + ystep * Double(i))
        }
        let series = ChartSeries(data:serieData)
        series.area = true
        // Configure chart layout
        series.color = ChartColors.maroonColor()
        chart.lineWidth = 0.5
        chart.labelFont = UIFont.systemFont(ofSize: 10)
        chart.xLabels = labels
        chart.yLabelsOnRightSide = true
//        chart.gridColor = .gray
        // Add some padding above the x-axis
        chart.yLabels = ylabels
        
        chart.yLabelsFormatter = {(labelIndex: Int, labelValue: Double) -> String in
            String(labelValue)
        }
        chart.add(series)
        
    }
    
}
