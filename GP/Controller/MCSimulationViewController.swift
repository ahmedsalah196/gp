import UIKit
import Charts
import SwiftChart
class MCSimulationViewController: UIViewController {
//    @IBOutlet weak var line: LineChartView!
    
    @IBOutlet weak var linr: Chart!
    let areaDrawer = AreaChart()
    var numberOfDaysToSimulate:Int? {
        didSet{
            curCommodity.monteCarlo.removeAll()
            refreshData()
        }
    }
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
            curCommodity.monteCarlo(days: numberOfDaysToSimulate ?? 20, completion: { [weak self] (response) in
                if let self = self,
                    let xs = response["price_array"] as? [Double],
                    let ys = response["fit"] as? [Double]
                {
                    self.updateGraph(xs: xs, ys: ys)
                }
            })
            
            
        }
    }
    func updateGraph(xs xValues:[Double],ys yValues:[Double] ){
        areaDrawer.initializeChart(chart: linr,
                                   prices: xValues,
                                   fit: yValues)
    }
    
    @IBAction func resimulate(_ sender: Any) {
        let alertView = UIAlertController(title: "Resimulate", message: "Enter your prefered simulation data", preferredStyle: .alert)
        alertView.addTextField { (textfield) in
            textfield.textColor = .blue
            textfield.placeholder = "Days to be simulated"
            textfield.keyboardType = .numberPad
        }
        alertView.addTextField { (textfield) in
            textfield.textColor = .blue
            textfield.placeholder = "Number of simulations"
            textfield.keyboardType = .numberPad
        }
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel)
        alertView.addAction(cancelaction)
        let processAction = UIAlertAction(title: "Process", style: .default) { [weak self](action) in
            if let self = self,
                let textfield = alertView.textFields?.first,
                let text = textfield.text,
                let number = Int(text)
                    {
                        self.numberOfDaysToSimulate = number
                    }
            }
        alertView.addAction(processAction)
        present(alertView, animated: true, completion: nil)
        
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
