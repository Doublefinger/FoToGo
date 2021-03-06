//
//  Constants.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 16/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

struct Constants {
    struct Messages {
        static let success = "success"
        static let notVerified = "Email has not been verified."
    }
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
        static let DisplayProfile = "displayProfile"
        static let PickOrder = "orderPicked"
        static let IncreaseBadge = "increaseBadge"
        static let RemoveBadge = "removeBadge"
        static let UpdateTrackOrder = "updateTrackOrder"
        static let UpdateOrderDetail = "updateOrderDetail"
    }
    
    struct Segues {
        static let BeginRegistration = "BeginRegistration"
        static let BeginSignIn = "BeginSignIn"
        static let ExitAccountSettings = "ExitAccountSettings"
        static let SignOut = "SignOut"
        static let ShowOrderContent = "ShowOrderContent"
        static let ShowEstimateCost = "ShowEstimateCost"
        static let ShowDeliverAfterTime = "ShowDeliverAfterTime"
        static let ShowDeliverBeforeTime = "ShowDeliverBeforeTime"
        static let ShowSearchFood = "ShowSearchFood"
    }
    
    struct UserFields {
        static let id = "uid"
        static let mobile = "mobile"
        static let year = "year"
        static let name = "name"
        static let imagePath = "imagePath"
    }
    
    struct OrderFields {
        static let account = "account"
        static let pickedBy = "pickedBy"
        static let deliverAfter = "deliverAfter"
        static let deliverBefore = "deliverBefore"
        static let madeTime = "madeTime"
        static let orderContent = "orderContent"
        static let estimateCost = "estimateCost"
        static let paidAmount = "paidAmount"
        static let paymentLocationVerified = "paymentLocationVerified"
        static let restaurantName = "restName"
        static let restaurantId = "restaurantId"
        static let destinationName = "destName"
        static let destinationId = "destinationId"
        static let state = "state"
        static let restaurantLatitude = "restLati"
        static let restaurantLongitude = "restLong"
        static let destinationLatitude = "destLati"
        static let destinationLongitude = "destLong"
        static let checked = "checked"
        static let cashOnly = "cashOnly"
    }
    
    struct OrderStates {
        static let drop = -1
        static let wait = 0
        static let pick = 1
        static let delivering = 2
        static let arrived = 3
        static let attemptToPay = 4
        static let paymentRequested = 5
        static let complete = 6
    }
}
