//
//  UserInfo.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 07/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import Foundation
import UIKit

public struct UserInfo {
    var firstName = ""
    var lastName = ""
    var mobile = ""
    var email = ""
    var major = ""
    var password = ""
    var photo = UIImage()
    var empty = true
    
    init() {}
    
    init(firstName: String, lastName: String, mobile: String, email: String, major: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = mobile
        self.email = email
        self.major = major
        self.password = password
        self.empty = false
    }
    
    init(firstName: String, lastName: String, mobile: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = mobile
        self.empty = false
    }
}
