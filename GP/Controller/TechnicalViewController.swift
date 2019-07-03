import UIKit
import Charts

class TechnicalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var curCommodity:Commodity!
    let technicalIndicators = ["Simple moving average","Exp moving average","MACD","RSI"]
    
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var line: LineChartView!
    let linedrawer = lineDrawer.sharedinstance
    var selectedIndex:Int = 0{
        didSet {
            let curchoice = curCommodity.technicalAnalysisTags[selectedIndex]
            let drawData = curCommodity.technicalAnalysis[curchoice]?.getLast(20)
            linedrawer.updateGraph(line:line, with: drawData!)
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
            curCommodity.loopForTA {
                self.selectedIndex = 0
            }
        }
        
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
