import UIKit
import Charts
class lineChartController: UIViewController {
    
    @IBOutlet weak var line: LineChartView!
    @IBOutlet weak var commodityTitle: UILabel!
    @IBOutlet weak var choice: UISegmentedControl!
    
    var curCommodity: Commodity!
    let linedrawer = lineDrawer.sharedinstance
    var activity: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        choice.addTarget(self, action: #selector(handlechangeEvent), for: UIControl.Event.valueChanged)
    }
    func showLoading(){
        activity = UIActivityIndicatorView(style: .gray)
        activity?.frame = view.bounds
        view.addSubview(activity!)
        activity?.startAnimating()
    }
    func hideLoading(){
        activity?.removeFromSuperview()
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
            line.isHidden = true
            showLoading()
            curCommodity.loopForPrices {
                [unowned self] in
                self.handlechangeEvent()
                
            }
        }
    }
    
    func animateLineView(){
        hideLoading()
        UIView.transition(with: line, duration: 0.4, options: .transitionCrossDissolve , animations: {
            self.line.isHidden = false
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func handlechangeEvent(){
        let daily = choice.selectedSegmentIndex
        let curChoice = curCommodity.pricesTags[daily]
        guard let prices = curCommodity.prices[curChoice] else {return}
        let dispData = prices.getLast(20)
        hideLoading()
        animateLineView()
        linedrawer.updateGraph(line:line,with:dispData,label: "Historical Prices", color: themeColor, weekly: (daily == 0 ? false : true))
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


