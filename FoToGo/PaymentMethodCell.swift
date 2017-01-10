//
//  MakeOrderTableViewCellWithSwitch.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 10/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var paymentSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
