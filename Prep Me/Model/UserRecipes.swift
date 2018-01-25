//
//  File.swift
//  Prep Me
//
//  Created by Kristopher Valas on 12/13/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import Foundation

class UserRecipes{
    
    var ingredients = [String]()
    var instructions = ""
    var category = ""
    
    init(ingredients : [String], instructions : String, category : String) {
        self.ingredients = ingredients
        self.category = category
        self.instructions = instructions
    }
    
}
