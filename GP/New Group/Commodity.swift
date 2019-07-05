import UIKit
class Commodity {
    var tag: String{
        didSet{
            prices.removeAll()
            technicalAnalysis.removeAll()
            monteCarlo.removeAll()
            news.removeAll()
            URLcreator()
        }
    }
    var macdData: MACDData!
    let commoditiesImages = [
        "gold": #imageLiteral(resourceName: "gold"),
        "corn":#imageLiteral(resourceName: "corn"),
        "crudeoil": #imageLiteral(resourceName: "oil")
    ]
    let commoditiesNames = [
        "gold": "Gold",
        "corn": "Corn",
        "crudeoil": "Crude oil"
    ]
    let newsURLS = [
        "corn": "https://newsapi.org/v2/everything?q=corn%20commodity&apiKey=e7ae60174c294d74a4ddf5868095f07b",
        "gold": "https://newsapi.org/v2/everything?q=gold%20commodity&apiKey=e7ae60174c294d74a4ddf5868095f07b",
        "crudeoil": " https://newsapi.org/v2/everything?q=oil%20commodity&apiKey=e7ae60174c294d74a4ddf5868095f07b"
    ]
    var newsUrl: String {
        get{
            return newsURLS[tag]!
        }
    }
    static let sharedinstance = Commodity(name: "gold")
    let apiURL = "https://shielded-ravine-75376.herokuapp.com/"
    var commodityURL: String!
    var prices = [String: Array<Double>] ()
    var pricesTags = ["daily","weekly"]
    var news:[News] = [News]()
    var technicalAnalysis = [String:CommodityTechnicalIndicatores]()
    var technicalAnalysisTags = ["sma","ema","macd","rsi"]
    var predictedPrice: Int = 30
    var monteCarlo = [String:Any]()
    let datafetcher: HistPrices
    let group = DispatchGroup()
    init(name:String) {
        self.tag = name
        datafetcher = HistPrices()
        URLcreator()
    }
    
    func URLcreator(){
        commodityURL = apiURL + tag + "/"
        print("creating")
        
    }
    func loopForPrices(completion: @escaping ()-> Void){
        print("looping")
        var ret = [String: Array<Double>]()
        let group = DispatchGroup()
        DispatchQueue.concurrentPerform(iterations: pricesTags.count) { (index) in
            let tag = pricesTags[index]
            let urlString = commodityURL.concat(tag)
            group.enter()
            datafetcher.fetchPrices(from: urlString, completion: { (result) in
                ret[tag] = result
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.main) {
            self.prices = ret
            completion()
        }
    }
    func loopForTA(completion: @escaping ()-> Void){
        var ret = [String: Array<Double>]()
        let group = DispatchGroup()
        DispatchQueue.concurrentPerform(iterations: technicalAnalysisTags.count) { (index) in
            let tag = technicalAnalysisTags[index]
            let urlString = commodityURL.concat(tag)
            group.enter()
            if index != 2 {
                datafetcher.fetchPrices(from: urlString, completion: { (result) in
                    ret[tag] = result
                    group.leave()
                })
            }
            else {
                datafetcher.getMACD { (MACDData) in
                    ret["macd"] = MACDData.macd
                    ret["Signal"] = MACDData.signal
                    group.leave()
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.technicalAnalysisTags.forEach { tag in
                let ct = CommodityTechnicalIndicatores( values: ret[tag]!)
                self.technicalAnalysis[tag] = ct
                if tag == "macd" {
                    self.technicalAnalysis[tag]!.extraData(values: ret["Signal"]!)
                }
            }
            completion()
        }
    }
    
    func getNews(completion:@escaping ()-> Void){
        let newsfetcher = NewsFetcher.sharedinstance
        newsfetcher.fetchNews(url: newsUrl) { [weak self](result) in
            guard let result = result,let self = self else {
                return
            }
            self.news = result
            completion()
        }
    }
    func getImg() -> UIImage {
        if let image = commoditiesImages[tag]{
            return image
        }
        else {
            return UIImage()
        }
    }
    func getName() -> String {
        return commoditiesNames[tag]!
    }
    func getPrice(completion: @escaping (Int)-> Void){
        datafetcher.getPredictedPrice(tag: tag) { [weak self] (price) in
            if let price = price,
                let self = self
            {
                self.predictedPrice = price
                completion(price)
            }
        }
    }
    func monteCarlo(days: Int,completion: @escaping ([String:Any])->Void){
        datafetcher.getMonteCarlo(days,tag: tag) {[weak self] (response) in
            if let response = response,
                let self = self
            {
                self.monteCarlo = response
                completion(response)
            }
        }
    }
    
}

extension String{
    func concat(_ str: String )-> String{
        return "\(self)\(str)"
    }
}
