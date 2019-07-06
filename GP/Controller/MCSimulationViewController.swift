import UIKit
import Charts
import SwiftChart
class MCSimulationViewController: UIViewController {
    
    @IBOutlet weak var linr: Chart!
    
    @IBOutlet weak var resimulateBtn: UIButton!
    @IBOutlet weak var VAR: UILabel!
    var activity: UIActivityIndicatorView?

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
            showLoading()
            curCommodity.monteCarlo(days: numberOfDaysToSimulate ?? 20, completion: { [weak self] (response) in
                
                guard let self = self,
                    let xs = response["price_array"] as? [Double],
                    let ys = response["fit"] as? [Double]
                    else
                {
                    return
                }
                self.hideLoading()
                self.updateGraph(xs: xs, ys: ys)
                self.linr.isHidden = true
                self.VAR.isHidden = true
                self.animateLineView(view: self.linr)
            })
           
            
            
        }
    }
    
    func showLoading(){
        activity = UIActivityIndicatorView(style: .gray)
        resimulateBtn.isEnabled = false
        activity?.frame = view.bounds
        view.addSubview(activity!)
        activity?.startAnimating()
    }
    func hideLoading(){
        activity?.removeFromSuperview()
        resimulateBtn.isEnabled = true
    }
    
    func animateLineView(view : UIView){
        UIView.transition(with: view, duration: 0.4, options: .transitionCrossDissolve , animations: {
            view.isHidden = false
        })
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
