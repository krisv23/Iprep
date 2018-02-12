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
    @IBOutlet weak var leftoversText: UILabel!
    
    var calories = " "
    var ingredients = [String]()
    var ingredientsFormatted = [String]()
    var leftovers = " "
    var servings = " "
    var instructions = " "
    var name = " "
    var recipeID = " "
    
    var selectedRecipes = [RecipeModel]()
    let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Recipes.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        recipeName.text = name
        servingLabel.text = servings
        instructionsText.text = instructions
        calorieLabel.text = calories
        leftoversText.text = leftovers
        formatIngredients()
    }

    //MARK : Fire off data saves, decode used to first pull in saved information and save used to add the newly appended item to the plist.
    @IBAction func mkeThisPressed(_ sender: UIButton) {
        
        print("Inside makethis")
        decodeData()
        
        let newRecipe = RecipeModel(recipeName: name, calories: calories, recipeID: recipeID, instructions: instructions, leftovers: leftovers, ingredients: ingredients, servings : servings)
        if(selectedRecipes.contains(newRecipe)){
            alertMessage(message: "This recipe already exists in your list!", title: "Already Exists!")
        }else {
            selectedRecipes.append(newRecipe)
            encodeData()
            alertMessage(message: "Recipe added!", title: "Success!")
        }
        

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
  

    
    func encodeData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(selectedRecipes)
            try data.write(to: dataURL!)
        }catch {
            print("Error in encoding recipes : \(error.localizedDescription)")
        }
    }
    
    func decodeData() {
    
        if let data = try? Data(contentsOf: dataURL!){
            let decoder = PropertyListDecoder()
            do{
                selectedRecipes = try decoder.decode([RecipeModel].self, from: data)
            }catch{
                print("Error decoding recipe: \(error.localizedDescription)")
            }
        }
        
        
    }
    
    func alertMessage (message : String, title : String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if(title == "Already Exists!"){
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(action)
        }else {
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                print("User tapped ok")
            })
            alertVC.addAction(action)
        }
        
        self.present(alertVC, animated: true, completion: nil)

    }

    
}
