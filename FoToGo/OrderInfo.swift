//
//  OrderInfo.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 02/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import Foundation

struct OrderInfo {
    var id = ""
    var account = ""
    var pickedBy = ""
    var state = ""
    var restaurantName = ""
    var restaurantId = ""
    var destinationName = ""
    var madeTime = ""
    var expectedTime = ""
    var pickedTime = ""
    
    init(id: String, account: String, pickedBy: String, state: String, restaurantName: String, restaurantId: String, destinationName: String, madeTime: String) {
        self.id = id
        self.account = account
        self.pickedBy = pickedBy
        self.madeTime = madeTime
        self.state = state
        self.restaurantName = restaurantName
        self.restaurantId = restaurantId
        self.destinationName = destinationName
    }
}
