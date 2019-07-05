//
//  lineDrawer.swift
//  GP2
//
//  Created by Ahmed Salah on 5/28/19.
//  Copyright © 2019 Ahmed Salah. All rights reserved.
//

import UIKit
import Charts

class LineFilledGraph: NSObject {
    static let sharedinstance = LineFilledGraph()
    private override init() {
        super.init()
    }
    
    func updateGraph(line: LineChartView,
                     prices xs: [Double],
                     fit ys: [Double])
    {
        var lineChartEntry  = [ChartDataEntry]()
        
        for i in 0..<xs.count {
            
            let value = ChartDataEntry(x: (xs[i] - xs.first!)*100, y: ys[i])
            lineChartEntry.append(value)
        }
        let lineDataSet = LineChartDataSet(values: lineChartEntry, label: "Probability")
        lineDataSet.colors = [UIColor.blue]
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.drawValuesEnabled = false
        lineDataSet.drawFilledEnabled = true
        lineDataSet.fillColor = UIColor.blue
        lineDataSet.fillAlpha = 0.9
        let data = LineChartData()
        data.addDataSet(lineDataSet)
        line.data = data
        line.chartDescription?.text = "Monte Carlo Simulation"
        line.backgroundColor = UIColor.clear
        line.chartDescription?.textColor = UIColor.blue
        line.xAxis.labelTextColor = UIColor.blue
        line.gridBackgroundColor = NSUIColor.blue
        line.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
}
