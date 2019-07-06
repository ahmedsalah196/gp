//
//  NewsTableViewCell.swift
//  GP
//
//  Created by Ahmed Salah on 6/26/19.
//  Copyright © 2019 Ahmed Salah. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    

    @IBOutlet weak var newsDescription: UILabel!
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    
    func setCell(title:String,
                 description: String,
                 url img: String?){
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        newsImage.addSubview(activityIndicator)
        activityIndicator.frame = newsImage.bounds
        activityIndicator.startAnimating()
        newsImage.image = nil
        newsTitle.text = title
        newsDescription.textColor = UIColor(red: 0.75,
                                            green: 0.75,
                                            blue: 0.75,
                                            alpha: 1.0)
        newsDescription.text = description
//        guard let img = img else {
////            self.newsImage.image = logo
//            return
//        }
//        NewsFetcher.sharedinstance.getImg(url: img) { [weak self](image) in
//            guard let image = image, let self = self else {return}
//            self.newsImage.image = image
//    }
        }
    func setImage(img: UIImage){
        for view in newsImage.subviews{
            if let view = view as? UIActivityIndicatorView{
                view.removeFromSuperview()
            }
        }
        newsImage.image = img
    }

}
