//
//  OrderTableViewCell.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 04/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
