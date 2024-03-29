import UIKit
import Charts
let numberOfPointsToBeDrawn = 20
class TechnicalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var curCommodity:Commodity!
    let technicalIndicators = ["Simple moving average","Exp moving average","MACD","RSI"]
    
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var line: LineChartView!
    var activity: UIActivityIndicatorView?
    let linedrawer = lineDrawer.sharedinstance
    var selectedIndex:Int = 0{
        didSet {
            let curchoice = curCommodity.technicalAnalysisTags[selectedIndex]
            let currentData = curCommodity.technicalAnalysis[curchoice]!
            if selectedIndex != 2{
            linedrawer.updateGraph(line:line, with: currentData.dataArray.getLast(numberOfPointsToBeDrawn), label: technicalIndicators[selectedIndex],color: themeColor,weekly: false)
            }
            else {
                linedrawer.updateGraphwithMACD(line: line, sets: [currentData.dataArray.getLast(numberOfPointsToBeDrawn),currentData.extraArray!.getLast(numberOfPointsToBeDrawn)], labels: ["MACD","Signal"], colors: [themeColor,#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)])
            }
            btnName.isEnabled = true
            animateLineView(view: line)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnName.setTitle(technicalIndicators.first, for: .normal)
        tblview.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    func refreshData(){
        guard let tabBarVC = tabBarController as? CommoditiesTabBarController else {
            return
        }
        curCommodity = tabBarVC.curCommodity
        if curCommodity.technicalAnalysis.isEmpty {
            btnName.isEnabled = false
            animate(toggle: true)
            showLoading()
            curCommodity.loopForTA {
                self.hideLoading()
                let x = self.selectedIndex
                self.selectedIndex = x
            }
        }
        
    }
    
    private func showLoading(){
        activity = UIActivityIndicatorView(style: .gray)
        activity?.frame = line.bounds
        line.addSubview(activity!)
        activity?.startAnimating()
    }
    private func hideLoading(){
        activity?.removeFromSuperview()
    }
    
    private func animateLineView(view : UIView){
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve , animations: {
            view.isHidden = false
        })
    }
    
    @IBAction func showHideTable(_ sender: Any) {
        if(tblview.isHidden){
            animate(toggle: false)
        }
        else {
            animate(toggle: true)
        }
    }
    
    private func animate(toggle: Bool){
        UIView.animate(withDuration: 0.3) {
            self.btnName.isHidden = !toggle
            self.tblview.isHidden = toggle
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return technicalIndicators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = technicalIndicators[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnName.setTitle(technicalIndicators[indexPath.row], for: .normal)
        animate(toggle: true)
        selectedIndex = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else {
            return
        }
        settingsVC.callback = { [weak self] message in
            if let self = self {
                self.curCommodity.tag = message
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
