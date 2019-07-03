import UIKit
import Charts
class lineChartController: UIViewController {
    
    @IBOutlet weak var line: LineChartView!
    @IBOutlet weak var commodityTitle: UILabel!
    @IBOutlet weak var choice: UISegmentedControl!
    
    var curCommodity: Commodity!
    let linedrawer = lineDrawer.sharedinstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choice.addTarget(self, action: #selector(handlechangeEvent), for: UIControl.Event.valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    func refreshData(){
        guard let tabBarVC = tabBarController as? CommoditiesTabBarController else {
            return
        }
        curCommodity = tabBarVC.curCommodity
        commodityTitle.text = curCommodity.getName()
        if curCommodity.prices.isEmpty{
            curCommodity.loopForPrices {
                [unowned self] in
                self.handlechangeEvent()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func handlechangeEvent(){
        let curChoice = curCommodity.pricesTags[choice.selectedSegmentIndex]
        guard let prices = curCommodity.prices[curChoice] else {return}
        let dispData = prices.getLast(20)
        linedrawer.updateGraph(line:line,with:dispData)
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
extension Array where Element : Numeric
{
    func getLast(_ n: Int) -> [Element] {
        return Array(dropFirst(self.count-n))
    }
}


