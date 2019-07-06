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
        newsDescription.textColor = UIColor(red: 0.25,
                                            green: 0.25,
                                            blue: 0.25,
                                            alpha: 1.0)
        newsDescription.text = description
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
