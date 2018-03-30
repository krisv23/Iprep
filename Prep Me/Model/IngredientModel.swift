//
//  IngredientModel.swift
//  Prep Me
//
//  Created by Kristopher Valas on 1/3/18.
//  Copyright © 2018 Kristopher Valas. All rights reserved.
//

import Foundation

//Plan is to create an array of this class storing the name of the ingredient as the class name and setting the amount and unit, as I go through ingredients and add to list, check to see if name exists in array if it does then update existing one with new amount else add it to array
func ==(lhs: IngredientModel, rhs: IngredientModel) -> Bool {
    return lhs.name == rhs.name
}

class IngredientModel: Encodable, Decodable, Equatable {
    
    var amount = ""
    var unit = ""
    var name = ""
    
    init(amount : String, unit : String, name : String) {
        self.amount = amount
        self.unit = unit
        self.name = name
    }
    
    func combinedName() -> String {
        if amount != " " && unit != " "{
            return ("\(amount)  \(unit)  \(name)")
        }
            return name
    }
    
    //Call this function on the existing IngredientModel class in the array to update the current amount
//    func updateAmount(newAmount : Int) {
//        self.amount = self.amount + newAmount
//    }
    
    
}
