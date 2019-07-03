import UIKit
import Charts
class lineDrawer: NSObject {
    static let sharedinstance = lineDrawer()
    private override init() {
        super.init()
    }
    
    func updateGraph(line: LineChartView, with numbers: [Double]){
        var lineChartEntry  = [ChartDataEntry]()
        
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lineChartEntry.append(value)
        }
        
        let lineDataSet = LineChartDataSet(values: lineChartEntry, label: "Number")
        
        lineDataSet.colors = [UIColor.blue]
        lineDataSet.circleRadius = 2.0
        lineDataSet.setCircleColor(UIColor.blue)
        let data = LineChartData()
        data.addDataSet(lineDataSet)
        lineDataSet.drawValuesEnabled = false
        line.data = data
        line.chartDescription?.text = "Historical price"
        line.backgroundColor = UIColor.clear
        line.chartDescription?.textColor = UIColor.blue
        line.xAxis.labelTextColor = UIColor.blue
        line.gridBackgroundColor = NSUIColor.blue
        line.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    
}
