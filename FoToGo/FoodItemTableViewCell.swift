//
//  FoodItemTableViewCell.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 15/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit

class FoodItemTableViewCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changeQuantity(_ sender: Any) {
    }

}
