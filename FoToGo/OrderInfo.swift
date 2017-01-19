//
//  OrderInfo.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 02/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import Foundation
import UIKit

struct OrderInfo {
    var id = ""
    var account = ""
    var pickedBy = ""
    var state = ""
    var restaurantName = ""
    var photo = UIImage()
    var destinationName = ""
    var lastUpdate = ""
    var deliverBefore = ""
    var deliverAfter = ""
    var orderItems: [String]
    var orderQuantities: [Int]
    var estimateCost = ""
    
    init(id: String, account: String, pickedBy: String, state: String, restaurantName: String, photo: UIImage, destinationName: String, lastUpdate: String, deliverBefore: String, deliverAfter: String, orderItems: [String], orderQuantities: [Int], estimateCost: String) {
        self.id = id
        self.account = account
        self.pickedBy = pickedBy
        self.lastUpdate = lastUpdate
        self.deliverBefore = deliverBefore
        self.deliverAfter = deliverAfter
        self.state = state
        self.restaurantName = restaurantName
        self.destinationName = destinationName
        self.photo = photo
        self.orderItems = orderItems
        self.orderQuantities = orderQuantities
        self.estimateCost = estimateCost
    }
}
