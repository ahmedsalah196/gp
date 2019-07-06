import UIKit
import Alamofire
class HistPrices: NSObject {
    static let sharedInstance = HistPrices()
    private override init() {
        
    }
    let apiURL = "https://shielded-ravine-75376.herokuapp.com/"
    func fetchPrices(from url:String ,completion: @escaping ([Double]?) -> Void){
        guard let requestURL = URL(string: url) else {
            print("prices url not working!!")
            completion(nil)
            return
        }
        Alamofire.request(requestURL,
                           method: .get)
            .validate()
        .responseJSON { (response) in
            guard response.result.isSuccess else{
                print("Error while fetching prices:")
                    completion(nil)
                return
            }
            guard let value = response.result.value as? [Double] else {
                print("Malformed data received from fetchAllRooms service")
                completion(nil)
                return
            }
            completion(value)
        }
    }
    func getPrice(urlString: String, completion: @escaping (String)-> Void){
        let url = URL(string: urlString)
        guard let Url = url else { return }
        Alamofire.request(Url, method: .get)
        .validate()
            .response { (data) in
                if let data = data.data {
                    let predictedPrice = String(decoding: data, as: UTF8.self)
                completion(predictedPrice)
        }
    }
    }
    func getMonteCarlo(_ days: Int,
                       tag: String,
                       completion: @escaping ([String:Any]?)-> Void){
        
        let urlString = apiURL + tag + "/sim?days=\(days)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        Alamofire.request(url, method: .get)
        .validate()
            .responseJSON { (response) in
                guard let result = response.result.value as? [String:Any] else {
                    completion(nil)
                    return
                }
                completion(result)
        }
    }
    func getMACD(tag:String, completion: @escaping (MACDData)->Void){
        if let MACDUrl = URL(string: "https://shielded-ravine-75376.herokuapp.com/\(tag)/macd"){
            print(MACDUrl.absoluteString)
        Alamofire.request(MACDUrl,method: .get)
            .validate()
            .responseData { (response) in
                if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(MACDData.self,from: data)
                    completion(result)
                }
                catch let jsonerr{
                    print(jsonerr)
                }
            }
            }
            
        }
        
    }
}
