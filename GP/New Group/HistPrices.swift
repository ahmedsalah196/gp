import UIKit
import Alamofire
class HistPrices: NSObject {
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
    func getPredictedPrice(tag: String, completion: @escaping (Int?)-> Void){
        let url = URL(string: #"https://predapi.herokuapp.com/\#(tag)/dailypred"#)
        guard let Url = url else { return }
        Alamofire.request(Url, method: .get)
        .validate()
            .responseData { (response) in
                guard let data = response.data, let StringInt = String.init(data: data, encoding: String.Encoding.utf8) else{
                    completion(nil)
                    return
                }
                let predictedPrice = Int.init(StringInt)
                completion(predictedPrice)
        }
    }
    func getMonteCarlo(tag: String, completion: @escaping ([String:Any]?)-> Void){
        let urlString = apiURL + tag + "/sim"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        Alamofire.request(url)
        .validate()
            .responseJSON { (response) in
                guard let result = response.result.value as? [String:Any] else {
                    completion(nil)
                    return
                }
                completion(result)
        }
    }
}
