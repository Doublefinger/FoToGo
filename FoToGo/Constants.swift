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
        static let PickOrder = "orderPicked"
        static let IncreaseBadge = "increaseBadge"
        static let RemoveBadge = "removeBadge"
        static let UpdateTrackOrder = "updateTrackOrder"
    }
    
    struct Segues {
        static let SignInToFp = "SignInToFP"
        static let FpToSignIn = "FPToSignIn"
    }
    
    struct UserFields {
        static let id = "uid"
        static let mobile = "mobile"
        static let year = "year"
        static let name = "name"
    }
    
    struct OrderFields {
        static let account = "account"
        static let pickedBy = "pickedBy"
        static let expectedTime = "expectedTime"
        static let orderList = "orderList"
        static let estimateCost = "estimateCost"
        static let restaurantName = "restName"
        static let destinationName = "destName"
        static let state = "state"
        static let restaurantLatitude = "restLati"
        static let restaurantLongitude = "restLong"
        static let destinationLatitude = "destLati"
        static let destinationLongitude = "destLong"
        static let checked = "checked"
    }
    
    struct OrderStates {
        static let wait = "waiting"
        static let pick = "pick"
        static let drop = "drop"
        static let complete = "complete"
    }
}
