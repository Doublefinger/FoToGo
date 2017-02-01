//
//  Address.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 01/02/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import Foundation
import CoreLocation

class Address {
    var name: String
    var location: CLLocation
    
    init(name: String, location: CLLocation) {
        self.name = name
        self.location = location
    }
}
