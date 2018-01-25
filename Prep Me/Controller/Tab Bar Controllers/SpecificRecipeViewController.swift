//
//  SpecificRecipeViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 12/29/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import UIKit

class SpecificRecipeViewController: UIViewController {

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var ingredientsText: UILabel!
    @IBOutlet weak var instructionsText: UILabel!
    @IBOutlet weak var leftoversText\: UILabel!
    
    var calories = " "
    var ingredients = [String]()
    var ingredientsFormatted = [String]()
    var leftovers = " "
    var servings = " "
    var instructions = " "
    var name = " "
    var recipeID = " "
    
    var selectedRecipes : [RecipeModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        recipeName.text = name
        servingLabel.text = servings
        instructionsText.text = instructions

        calorieLabel.text = calories
        leftoversText.text = leftovers
        formatIngredients()
    }

    @IBAction func mkeThisPressed(_ sender: UIButton) {
        
        let newRecipe = RecipeModel()
        newRecipe.recipe.recipeName = name
        newRecipe.recipe.ingredients = ingredients
        newRecipe.recipe.recipeID = recipeID

        if (selectedRecipes?.isEmpty)! {
            selectedRecipes![0] = newRecipe
        }else {
            selectedRecipes?.append(newRecipe)
        }
        
        for recipe in selectedRecipes! {
            print(recipe)
        }
      //  print(selectedRecipes)
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        ingredients.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
    func formatIngredients() {
        
        ingredientsFormatted.removeAll()
        for string in ingredients {
            let formattedString = "\u{2022} \(string) \n"
            ingredientsFormatted.append(formattedString)
        }
        
        ingredientsText.text = ingredientsFormatted.joined(separator: "\n")
        ingredientsText.sizeToFit()
    }

    
}
