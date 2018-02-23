//
//  SpecificRecipeViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 12/29/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import UIKit

class SpecificRecipeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var ingredientsText: UILabel!
    @IBOutlet weak var instructionsText: UILabel!
    @IBOutlet weak var leftoversText: UILabel!
    @IBOutlet weak var dayPicker: UIPickerView!
    
    var calories = " "
    var ingredients = [String]()
    var ingredientsFormatted = [String]()
    var leftovers = " "
    var servings = " "
    var instructions = " "
    var name = " "
    var recipeID = " "
    var selectedDay = "Select One"
    let daysOfWeek = ["Select One", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var selectedRecipes = [RecipeModel]()
    let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Recipes.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayPicker.dataSource = self
        dayPicker.delegate = self
        print(dataURL!)
        
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
        
        decodeData()
        let newRecipe = RecipeModel()
        setRecipeValues(recipe: newRecipe)
        if(selectedRecipes.contains(newRecipe)){
            alertMessage(message: "This recipe already exists in your list!", title: "Already Exists!")
        }else if (selectedDay == "Select One"){
            alertMessage(message: "Please select a day of the week ", title: "Select One")
        }else {
            newRecipe.dayofWeek = selectedDay
            selectedRecipes.append(newRecipe)
            encodeData()
            alertMessage(message: "Recipe added!", title: "Success!")
        }
        

    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        ingredients.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Formatting of ingredients label.
    
    func formatIngredients() {
        
        ingredientsFormatted.removeAll()
        for string in ingredients {
            let formattedString = "\u{2022} \(string) \n"
            ingredientsFormatted.append(formattedString)
        }
        
        ingredientsText.text = ingredientsFormatted.joined(separator: "\n")
        ingredientsText.sizeToFit()
    }
  

    //MARK: Data manipulation
    
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
    
    
    //MARK : Date Picker functionality
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysOfWeek.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysOfWeek[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = daysOfWeek[row]
    }
    
    
    
    //MARK : Alert messages
    
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

    func setRecipeValues(recipe : RecipeModel){
        recipe.recipeName = name
        recipe.calories = calories
        recipe.recipeID = recipeID
        recipe.instructions = instructions
        recipe.leftovers = leftovers
        recipe.ingredients = ingredients
        recipe.servings = servings
    }
    
}
