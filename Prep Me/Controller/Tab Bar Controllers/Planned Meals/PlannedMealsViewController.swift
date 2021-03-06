//
//  PlannedMealsViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 2/9/18.
//  Copyright © 2018 Kristopher Valas. All rights reserved.
//
//NEED TO FIX DATA ON PHONE SIMULATOR

import UIKit

class PlannedMealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var mealTableView: UITableView!
    var selectedMeals = [RecipeModel]()
    var currentRow = 0
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var numberOfRowsinSection = [0,0,0,0,0,0,0]
    var orderedRecipes = [[RecipeModel]]()
    let recipeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Recipes.plist")
    let orderedURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Ordered.plist")
    let recipeString = "selectedMeals"
    let orderedString = "orderedArray"
    var chosenDish = RecipeModel()
    var selectedDay = 0
    let userDefaults = UserDefaults.standard
    var stateArray = ["none"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealTableView.delegate = self
        mealTableView.dataSource = self
        orderedRecipes = loadOrderedRecipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData(recipeString)
        loadData(orderedString)
        for recipe in selectedMeals {
            if recipe.added == false  {
                selectedDay = days.index(of: recipe.dayofWeek)!
                print(" In recipe added: \(numberOfRowsinSection)")
                print("Selected day : \(selectedDay)")
                orderedRecipes[selectedDay].remove(at: (numberOfRowsinSection[selectedDay] - 1))
                orderedRecipes[selectedDay].insert(recipe, at: (numberOfRowsinSection[selectedDay] - 1))
                //numberOfRowsinSection[selectedDay] += 1
                recipe.added = true
            }
            if recipe.dayChanged == true {
                print("inside day changed")
                print("Recipe name: \(recipe.recipeName)")
                let emptyMeal = RecipeModel()
                selectedDay = days.index(of: recipe.dayofWeek)!
                orderedRecipes[recipe.section].remove(at: recipe.row)
                orderedRecipes[recipe.section].insert(emptyMeal, at: recipe.row)
                orderedRecipes[selectedDay].remove(at: (numberOfRowsinSection[selectedDay] - 1))
                orderedRecipes[selectedDay].insert(recipe, at: (numberOfRowsinSection[selectedDay] - 1))
                updateRecipeLocation(section: recipe.section, row: recipe.row)
                recipe.dayChanged = false
            }
            encodeData(recipeString)
            mealTableView.reloadData()
            print(numberOfRowsinSection)
        }
    }

    func updateRecipeLocation(section : Int, row : Int) {
        
        switch row {
        case 0:
            orderedRecipes[section].swapAt(0, 1)
            orderedRecipes[section].swapAt(1, 2)
        case 1:
            orderedRecipes[section].swapAt(1, 2)
        default:
            print("Do nothing")
        }
    }
    
    @IBAction func clearRecipesPressed(_ sender: UIButton) {
        
        numberOfRowsinSection = [0,0,0,0,0,0,0]
        selectedMeals.removeAll()
        encodeData(recipeString)
        encodeData(orderedString)
        orderedRecipes = loadOrderedRecipe()
        mealTableView.reloadData()
        updateState()
    }
    
    
    //MARK: Tableview datasource/delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return orderedRecipes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = orderedRecipes[indexPath.section][indexPath.row].recipeName
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return days[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         chosenDish = orderedRecipes[indexPath.section][indexPath.row]
        chosenDish.section = indexPath.section
        chosenDish.row = indexPath.row
        if !(chosenDish.recipeName.isEmpty){
            mealTableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "PlannedSpecificRecipe", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete {
            if !orderedRecipes[indexPath.section][indexPath.row].recipeName.isEmpty {
                loadData(recipeString)
                loadData(orderedString)
                let indexofMeal = selectedMeals.index(of: orderedRecipes[indexPath.section][indexPath.row])
                updateState()
                orderedRecipes[indexPath.section].remove(at: indexPath.row)
                mealTableView.deleteRows(at: [indexPath], with: .top)
                deleteRow(section: indexPath.section, row: indexPath.row, index: indexofMeal!)
                tableView.reloadData()
            }

            
        }
    }
    
    func updateState() {
        if let localStateArray = userDefaults.stringArray(forKey: "operation")  {
            print("localArray = \(localStateArray)")
            stateArray = localStateArray
            stateArray.append("remove")
        } else {
            stateArray.append("remove")
        }
        
        userDefaults.set(stateArray, forKey: "operation")
        userDefaults.set(true, forKey: "state")
        
    }
    
    
    //MARK: Data manipulation methods
    //Encode saves the data to the users phone in a plist
    func encodeData(_ type : String) {
        let encoder = PropertyListEncoder()
        do{
            if type == "selectedMeals"{
                let data =  try encoder.encode(selectedMeals)
                try data.write(to: recipeURL!)
            }else {
                let data =  try encoder.encode(numberOfRowsinSection)
                try data.write(to: orderedURL!)
            }
        }catch {
            print("Error encoding data: \(error.localizedDescription)")
        }
        
    }
    //loadData loads either the meals or the 2d array of meals from the users phone into the app
    func loadData(_ type : String) {
        if type == "selectedMeals" {
            if let data = try? Data(contentsOf: recipeURL!){
                let decoder = PropertyListDecoder()
                do {
                    selectedMeals = try decoder.decode([RecipeModel].self, from: data)
                }catch {
                    print("Error decoding data: \(error)")
                }
            }
        } else {
            if let data = try? Data(contentsOf: orderedURL!){
                let decoder = PropertyListDecoder()
                do {
                    numberOfRowsinSection = try decoder.decode([Int].self, from: data)
                }catch {
                    print("Error decoding data: \(error)")
                }
            }
        }
        
    }
    
    func deleteRow(section : Int, row : Int, index : Int) {
        let emptyRecipe = RecipeModel()
        orderedRecipes[section].insert(emptyRecipe, at: row)
        updateRecipeLocation(section: section, row: row)
        selectedMeals.remove(at: index)
        numberOfRowsinSection[section] -= 1
        encodeData(recipeString)
        encodeData(orderedString)
    }
    
    
    //Allows the orderedRecipes array to pull in all recipes in the PLIST when the app is opened after being killed
    func loadOrderedRecipe() -> [[RecipeModel]] {
        print("Number in initial load \(numberOfRowsinSection)")
        var orderedList = instanstiateMultiArray()
        loadData(recipeString)
        for recipe in selectedMeals {
                let selectedDay = days.index(of: recipe.dayofWeek)!
                orderedList[selectedDay].remove(at: numberOfRowsinSection[selectedDay])
                orderedList[selectedDay].insert(recipe, at: numberOfRowsinSection[selectedDay])
                numberOfRowsinSection[selectedDay] += 1
            }
            print("Number after initial load \(numberOfRowsinSection)")
            encodeData(orderedString)
            return orderedList
        }
   
    //Instanstiates 2d array for custom object in order to add new updates and functionality.
    func instanstiateMultiArray() -> [[RecipeModel]] {
        
        var multiArray = [[RecipeModel]]()
        
        for i in 0...6 {
            multiArray.append([RecipeModel]())
            
            for _ in 0...2 {
                multiArray[i].append(RecipeModel())
            }
        }
        return multiArray
    }
    
    //MARK: Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlannedSpecificRecipe" {
            selectedDay = days.index(of: chosenDish.dayofWeek)!
            let destinationVC = segue.destination as? PlannedSpecificRecipeVC
            destinationVC?.chosenDish = chosenDish
            destinationVC?.selectedDay = selectedDay
            destinationVC?.ingredientsText = chosenDish.ingredients
        }
    }


}
