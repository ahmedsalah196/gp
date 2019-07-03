import UIKit
import Charts
import SwiftChart
class MCSimulationViewController: UIViewController {
//    @IBOutlet weak var line: LineChartView!
    
    @IBOutlet weak var linr: Chart!
    let areaDrawer = AreaChart()
    var curCommodity: Commodity!
    let lineDrawer = LineFilledGraph.sharedinstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    func refreshData(){
        guard let tabBarVC = tabBarController as? CommoditiesTabBarController else {
            return
        }
        curCommodity = tabBarVC.curCommodity
        if curCommodity.monteCarlo.isEmpty{
            curCommodity.monteCarlo { [weak self] (response) in
                if let self = self,
                    let xs = response["price_array"] as? [Double],
                    let ys = response["fit"] as? [Double]
                    {
                    self.updateGraph(xs: xs, ys: ys)
                }
            }
        }
    }
    func updateGraph(xs xValues:[Double],ys yValues:[Double] ){
        areaDrawer.initializeChart(chart: linr,
                                   prices: xValues,
                                   fit: yValues)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else {
            return
        }
        settingsVC.callback = { [unowned self] message in
            self.curCommodity.tag = message
        }
    }
}
