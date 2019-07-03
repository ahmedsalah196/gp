import UIKit

struct News: Decodable {
    let title: String
    let description: String
    let urlToImage: String?
    let url: String
}

struct JSONResult:Decodable {
    let articles:[News]
}
