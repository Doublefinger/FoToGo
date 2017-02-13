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
    var id: String
    var account: String
    var pickedBy: String
    var state: Int
    var restId: String
    var restAddress: Address
    var photo = UIImage()
    var destId: String
    var destAddress: Address
    var lastUpdate: String
    var deliverBefore: String
    var deliverAfter: String
    var orderItems: [String]
    var orderQuantities: [Int]
    var estimateCost: String
    var paidAmount: String
    var paymentLocationVerified: Int
    
    init(id: String, account: String, pickedBy: String, state: Int, restId: String, restAddress: Address, photo: UIImage, destId: String, destAddress: Address, lastUpdate: String, deliverBefore: String, deliverAfter: String, orderItems: [String], orderQuantities: [Int], estimateCost: String, paidAmount: String, paymentLocationVerified: Int) {
        self.id = id
        self.account = account
        self.pickedBy = pickedBy
        self.lastUpdate = lastUpdate
        self.deliverBefore = deliverBefore
        self.deliverAfter = deliverAfter
        self.state = state
        self.restId = restId
        self.restAddress = restAddress
        self.destId = destId
        self.destAddress = destAddress
        self.photo = photo
        self.orderItems = orderItems
        self.orderQuantities = orderQuantities
        self.estimateCost = estimateCost
        self.paidAmount = paidAmount
        self.paymentLocationVerified = paymentLocationVerified
    }
}
