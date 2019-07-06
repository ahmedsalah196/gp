import UIKit
import Charts
class lineDrawer: NSObject, IAxisValueFormatter {
    static let sharedinstance = lineDrawer()
    private override init() {
        super.init()
    }

    var matchingDates = [String]()
    
    func updateGraph(line: LineChartView, with numbers: [Double],label: String, color: UIColor, weekly: Bool){
        matchingDates.removeAll()
        let lineChartEntry = (0..<numbers.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: numbers[i])
        }
        
        let lineDataSet = LineChartDataSet(values: lineChartEntry, label: "Number")
        
        line.xAxis.valueFormatter = self
        let today = Date()
        let startDate = Calendar.current.date(byAdding: (weekly ? .weekOfMonth : .day), value: -1*numbers.count , to: today)!
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        calendar.enumerateDates(startingAfter: startDate, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date {
                if date <= today {
                    let weekday1 = calendar.component(Calendar.Component.weekday, from: date)
                    let todayWeekDay =  calendar.component(Calendar.Component.weekday, from: today)
                        if weekday1 == todayWeekDay || !weekly{
                            print(todayWeekDay, weekday1)
                    matchingDates.append(dateFormatter.string(from: date))
                        }
                } else {
                    stop = true
                }
            }
        }
        
        lineDataSet.colors = [color]
        lineDataSet.circleRadius = 2.0
        lineDataSet.setCircleColor(UIColor.blue)
        let data = LineChartData(dataSet: lineDataSet)
        lineDataSet.drawValuesEnabled = true
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
            dataset.circleRadius = 1.0
            dataset.setCircleColor(colors[i])
            return dataset
        }
        let data = LineChartData(dataSets: multisets)
        setupGraph(line: line,
                   label: "MACD",
                   color: themeColor,
                   data: data)
    }
    
    func setupGraph(line: LineChartView,
                    label: String,
                    color: UIColor,
                    data: LineChartData ){
        line.data = data
        line.chartDescription?.text = label
        line.backgroundColor = UIColor.clear
        line.chartDescription?.textColor = themeColor
        line.xAxis.labelTextColor = themeColor
        line.gridBackgroundColor = themeColor
        line.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return matchingDates[Int(value)]
    }
    
}


