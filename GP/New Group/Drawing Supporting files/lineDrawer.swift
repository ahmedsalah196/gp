import UIKit
import Charts
class lineDrawer: NSObject {
    static let sharedinstance = lineDrawer()
    private override init() {
        super.init()
    }
    
    func updateGraph(line: LineChartView, with numbers: [Double],label: String, color: UIColor){
        let lineChartEntry = (0..<numbers.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: numbers[i])
        }
        
        let lineDataSet = LineChartDataSet(values: lineChartEntry, label: "Number")
        
        lineDataSet.colors = [color]
        lineDataSet.circleRadius = 2.0
        lineDataSet.setCircleColor(UIColor.blue)
        let data = LineChartData()
        data.addDataSet(lineDataSet)
        lineDataSet.drawValuesEnabled = false
        setupGraph(line: line,
                   label: label,
                   color: color,
                   data: data)
    }
    func updateGraphwithMACD(line: LineChartView,
                             sets:[[Double]],
                             labels:[String],
                             colors:[UIColor]){
        let multisets = (0..<sets.count).map { (i) -> LineChartDataSet in
            let entries = (0..<sets[i].count).map { (j) -> ChartDataEntry in
                return ChartDataEntry(x: Double(j), y: sets[i][j])
            }
            let dataset = LineChartDataSet(values: entries, label: labels[i])
            dataset.colors = [colors[i]]
            dataset.circleRadius = 2.0
            dataset.setCircleColor(colors[i])
            dataset.drawValuesEnabled = false
            return dataset
        }
        let data = LineChartData(dataSets: multisets)
        setupGraph(line: line,
                   label: "MACD",
                   color: UIColor.blue,
                   data: data)
    }
    
    func setupGraph(line: LineChartView,
                    label: String,
                    color: UIColor,
                    data: LineChartData ){
        line.data = data
        line.chartDescription?.text = label
        line.backgroundColor = UIColor.clear
        line.chartDescription?.textColor = UIColor.blue
        line.xAxis.labelTextColor = UIColor.blue
        line.gridBackgroundColor = UIColor.blue
        line.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    
    
}
