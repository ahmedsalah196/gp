import UIKit
struct commodityData {
    let name:String
    let tag:String
    let image:UIImage
}
class SettingsViewController: UITableViewController {
//    let sectionHeaders = ["Commodities","Account"]
    let availableCommodities = [
        commodityData(name: "Gold",tag:"gold",image:#imageLiteral(resourceName: "gold")),
        commodityData(name: "Crude Oil",tag:"crudeoil",image:#imageLiteral(resourceName: "oil")),
        commodityData(name: "Corn",tag:"corn",image:#imageLiteral(resourceName: "corn"))
    ]
    var chosenTag: String?
    var callback: ((String) -> ())!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UILabel()
//        header.text = sectionHeaders[section]
//        header.textColor = .black
//        header.backgroundColor = .orange
//        header.font = UIFont.boldSystemFont(ofSize: 22)
//        header.textAlignment = .center
//        return header
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsTableViewCell
        let commodity = availableCommodities[indexPath.row]
        cell.setCell(img: commodity.image, name: commodity.name)
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

}
