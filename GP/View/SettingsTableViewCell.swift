//
//  SettingsTableViewCell.swift
//  GP
//
//  Created by Ahmed Salah on 6/26/19.
//  Copyright © 2019 Ahmed Salah. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var riseFall: UIImageView!
    
    func setCell(img: UIImage, name: String, rise: UIImage){
        icon.image = img
        self.name.text = "$"+name
        riseFall.image = rise
    }
}
