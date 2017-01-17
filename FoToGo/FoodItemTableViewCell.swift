//
//  FoodItemTableViewCell.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 15/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit
import GMStepper

class FoodItemTableViewCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodCount: GMStepper!
    
    var index = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
