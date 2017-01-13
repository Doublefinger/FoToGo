//
//  Food.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 12/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import Foundation

struct Food {
    var category: String
    var name: String
        
    init(category: String, name: String){
        self.category = category
        self.name = name
    }
}
