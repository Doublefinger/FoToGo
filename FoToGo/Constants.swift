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
    }
    
    struct Segues {
        static let SignInToFp = "SignInToFP"
        static let FpToSignIn = "FPToSignIn"
    }
    
    struct OrderFields {
        static let account = "account"
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
    }
    
}
