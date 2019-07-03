import UIKit
import Alamofire
class NewsFetcher: NSObject {
    static let sharedinstance = NewsFetcher()
    private override init() {
        super.init()
    }
    var newsImages = [UIImage]()
    func fetchNews(url: String , completion: @escaping ([News]?)->Void )
    {
        guard let requestURL = URL(string: url) else {
            print("news url not working")
            completion(nil)
            return
        }
        Alamofire.request(requestURL, method: .get)
        .validate()
            .responseData { (response) in
                guard let data = response.data else{
                    print("error with data")
                    completion(nil)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(JSONResult.self, from: data)
                    completion(result.articles)
                }
                catch let jsonerr{
                    print(jsonerr)
                }
        }
    }
    func getImg(urlString: String?, completion: @escaping(UIImage?)-> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else{
            completion(nil)
            return
        }
        Alamofire.request(url)
        .validate()
            .responseData { (response) in
                guard let data = response.data else {
                    print("no data!!")
                    completion(nil)
                    return
                }
                guard let img = UIImage(data: data) else {
                    print("not an image!!")
                    completion(nil)
                    return
                }
                completion(img)
        }
    }
}
