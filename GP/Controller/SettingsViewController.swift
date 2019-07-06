import UIKit
struct commodityData {
    let tag:String
    let image:UIImage
}

let themeColor = #colorLiteral(red: 0.2352941176, green: 0.2117647059, blue: 0.431372549, alpha: 1)
class SettingsViewController: UITableViewController {
    let availableCommodities = [
        commodityData(tag:"gold",image:#imageLiteral(resourceName: "gold") ),
        commodityData(tag:"crudeoil",image:#imageLiteral(resourceName: "petrolbarrel") ),
        commodityData(tag:"corn",image:#imageLiteral(resourceName: "corn") )
    ]
    var chosenTag: String?
    var callback: ((String) -> ())!
    var prices:[String:Double] = [String:Double]()
    let tags = ["gold",
                "crudeoil",
                "corn"]
    let extensions = ["today","dailypred"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        tableView.separatorColor = themeColor
        tableView.sectionHeaderHeight = 60
        tableView.rowHeight = 70
    }
    override func viewWillAppear(_ animated: Bool) {
        tags.forEach { (tag) in
            extensions.forEach { (ext) in
                prices[tag+ext] = UserDefaults.standard.double(forKey: tag+ext) ?? 30
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = "Commodities"
        header.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        header.backgroundColor = themeColor
        header.font = UIFont.systemFont(ofSize: 30)
        header.textAlignment = .center
        return header
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsTableViewCell
        let commodity = availableCommodities[indexPath.row]
        let predictedprice = prices[commodity.tag + "dailypred"]!
        let today = prices[commodity.tag + "today"]!
        cell.setCell(img: commodity.image, name: String(predictedprice), rise: (predictedprice > today ? #imageLiteral(resourceName: "greenarrow") : #imageLiteral(resourceName: "redarrow")))
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return availableCommodities.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        callback?(availableCommodities[indexPath.row].tag)
        self.navigationController?.popViewController(animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        }
    }
}
