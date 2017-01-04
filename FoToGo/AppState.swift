//
//  AppState.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 15/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import Foundation
import UIKit

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var uid: String?
    var mobile: String?
    var email: String?
    var year: String?
    var displayName: String?
    var profileImage: UIImage?
    var uncheckedOrders: [String]?
    
    func clear(){
        signedIn = false
        uid = nil
        mobile = nil
        email = nil
        year = nil
        displayName = nil
        profileImage = nil
        uncheckedOrders = nil
    }
}
