import UIKit

class NewsTableViewController: UITableViewController {

    var curCommodity: Commodity!
    let newsFetcher = NewsFetcher.sharedinstance
    var newsImages = [Int:UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        
    }
    override func viewWillAppear(_ animated: Bool) {
        hideLoading()
        refreshData()
    }
    func refreshData(){
        guard let tabBarVC = tabBarController as? CommoditiesTabBarController else {
            return
        }
        curCommodity = tabBarVC.curCommodity
        if curCommodity.news.isEmpty{
            self.showLoading()
            curCommodity.getNews { [weak self] in
                if let self = self{
                    self.newsImages.removeAll()
                    UIView.animate(withDuration: 0.4) {
                    self.tableView.reloadData()
                    }
                    self.hideLoading()
                }
            }
        }
    }
    var activity: UIActivityIndicatorView?
    func showLoading(){
        activity = UIActivityIndicatorView(style: .gray)
        activity?.frame = view.bounds
        view.addSubview(activity!)
        activity?.startAnimating()
    }
    func hideLoading(){
        activity?.removeFromSuperview()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curCommodity.news.count
    }
    
    func getindexPaths(length: Int) -> [IndexPath]{
        
        return (0..<length).map { (i) -> IndexPath in
            IndexPath(row: i, section: 0)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "newsCell",
            for: indexPath) as! NewsTableViewCell
        let ind = indexPath.row
        let currentNews = curCommodity.news[ind]
        cell.setCell(title: currentNews.title, description: currentNews.description, url: currentNews.urlToImage)
        if let img = newsImages[ind]{
            cell.setImage(img: img)
        }
        else {
            newsFetcher.getImg(urlString: currentNews.urlToImage) { (image) in
                self.newsImages[ind] = image
                if let image = image,
                    tableView.visibleCells.contains(cell)
                {
                    cell.setImage(img: image)
                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingsVC = segue.destination as? SettingsViewController
        {
            settingsVC.callback = { [weak self] message in
                if let self = self {
                    self.curCommodity.tag = message
                    print("---------------\n" + message + "\n---------------")
                }
            }
        }
        else if let webVC = segue.destination as? WebViewController {
            let index = tableView.indexPathForSelectedRow?.row
            if let index = index
            {
                let news = curCommodity.news[index]
                webVC.urlstring = news.url
            }
        }
        
    }
}
