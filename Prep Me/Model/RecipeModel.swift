//
//  File.swift
//  Prep Me
//
//  Created by Kristopher Valas on 1/3/18.
//  Copyright © 2018 Kristopher Valas. All rights reserved.
//

import Foundation

//struct Recipe {
//    var recipeName : String?
//    var recipeID : String?
//    var ingredients : [String]?
//}
//This class keeps track of the recipes selected to be made. An object of this class will be stored in an array of all recipes currently set to be made. The array will be passed around view controllers to keep track of the state of the recipes.

class RecipeModel  {
    
    var recipeName = ""
    var calories = ""
    var recipeID = ""
    var instructions = ""
    var leftovers = ""
    var servins = ""
    var ingredients = [String]()
    
    init(recipeName : String, calories : String, recipeID : String, instructions: String, leftovers : String, ingredients : [String]) {
        self.recipeName = recipeName
        self.calories = calories
        self.recipeID = recipeID
        self.instructions = instructions
        self.leftovers = leftovers
        self.ingredients = ingredients
    }
    
    
}
