//
//  ShoppingListVC.swift
//  Prep Me
//
//  Created by Kristopher Valas on 3/19/18.
//  Copyright © 2018 Kristopher Valas. All rights reserved.
//

import UIKit

class ShoppingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sectionNames = ["Shopping Cart", "Completed"]
    var selectedMeals = [RecipeModel]()
    var ingredientsObjects = [IngredientModel]()
    var completedIngredients = [IngredientModel]()
    var ingredientList = [String]()
    var array = [String]()
    var name = " "
    var amount = 0.0
    var unit = " "
    let userDefaults = UserDefaults.standard
    var updateState = false
    var removeCount = 0
    
    @IBOutlet weak var emptyListLabel: UILabel!
    
    let localArray = ["none"]

    let recipeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Recipes.plist")
    let shoppingURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("shoppingList.plist")
    let completedURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("completedList.plist")

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
//        loadData("recipes")
//        if loadData("shopping") == 0 || loadData("completed") == 0 {
//            loadIngredients()
//        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        super.viewDidLoad()
    }
    
    //TODO: Need to load shopping and completed list if not null and then display those ingredients in each, when view exiting need to save updated list for both arrays
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData("recipes")
        updateState = false
        if let state = userDefaults.value(forKey: "state") as? Bool {
            if state {
                updateState = true
            }
        }
            //Handles if a recipe is added or removed.
        if updateState {
            stateChange()
        }else {
//            loadData("shopping")
//            loadData("completed")
//            loadIngredients()
            if loadData("shopping") == 0 || loadData("completed") == 0 {
                loadIngredients()
                initIngredients()
            }
        
        }
        
        
        //Need to think about how to check if new recipes are added and how to append them to shopping cart.
//        print("ingredient object count : \(ingredientsObjects.count)")
//        print("completed object count: \(completedIngredients.count)")
//        print("selected meals count: \(selectedMeals.count)")
        if (ingredientsObjects.count == 0 && completedIngredients.count == 0 && selectedMeals.count != 0){
            loadIngredients()
            initIngredients()
        }
        
        if (selectedMeals.count == 0) {
            emptyListLabel.isHidden = false
        }else {
            emptyListLabel.isHidden = true

        }

        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("Saving shopping & Completed")
        saveData("shopping")
        saveData("completed")
    }
    
    //MARK: Tableview datasource and delegation methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return ingredientsObjects.count
        }else  {
            return completedIngredients.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellList", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = ingredientsObjects[indexPath.row].combinedName()
            cell.accessoryType = .none
        }else if indexPath.section == 1 {
            cell.textLabel?.text = completedIngredients[indexPath.row].combinedName()
            cell.accessoryType = .checkmark
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            completedIngredients.append(ingredientsObjects[indexPath.row])
            ingredientsObjects.remove(at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
        }else {
            ingredientsObjects.append(completedIngredients[indexPath.row])
            completedIngredients.remove(at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
        }
    }
    
    //MARK: Data manipulation methods
    func loadData(_ whichOP : String) -> Int {
        switch whichOP {
        case "recipes":
            if let data = try? Data(contentsOf: recipeURL!){
                let decoder = PropertyListDecoder()
                do {
                    selectedMeals = try decoder.decode([RecipeModel].self, from: data)
                    return 1
                }catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
        case "shopping":
            print("In shopping")
            if let data = try? Data(contentsOf: shoppingURL!){
                let decoder = PropertyListDecoder()
                do {
                    ingredientsObjects = try decoder.decode([IngredientModel].self, from: data)
                    print(ingredientsObjects)
                    return 1
                }catch {
                    print("In catch statement of shopping case must do something...")
                }
            }else {
                print("Did not enter if statement for case: Shopping " )
                return 0
            }
        case "completed":
            print("in completed")
            if let data = try? Data(contentsOf: completedURL!){
                let decoder = PropertyListDecoder()
                do {
                    completedIngredients = try decoder.decode([IngredientModel].self, from: data)
                    print(completedIngredients)
                    return 1
                } catch {
                    print("In catch statement of completed case must do something...")
                }
            } else {
                print("Did not enter if statement for case: completed")
                return 0
            }
            
        default:
            print("Fail whale :(")
            return 1
        }

        return 1
    }
    
    func saveData(_ type : String) {
        let encoder = PropertyListEncoder()
        do {
            if type == "shopping"{
                let data = try encoder.encode(ingredientsObjects)
                try data.write(to: shoppingURL!)
            }else {
                let data = try encoder.encode(completedIngredients)
                try data.write(to: completedURL!)
            }
            
        }catch{
            print("Error in attempting to write data")
        }
        
    }
    
    
    //MARK: Ingredient Initializers
    func loadIngredients() {
        print("Inside loadIngredients")
        ingredientList.removeAll()
        for recipe in selectedMeals {
            for ingredient in recipe.ingredients {
                print("Ingredient: \(ingredient)")
                ingredientList.append(ingredient)
                
            }
        }
        print(ingredientList)
     //   initIngredients()
    }
    
    //Function for first time load, loads all ingredients and add them one by one to the shopping list.
    func initIngredients() {
        

        for ingredient in ingredientList {
            array = ingredient.components(separatedBy: " ")
            if array.count < 3 {
                let ingredientObj = IngredientModel(amount: " ", unit: " ", name: array[0])
                ingredientsObjects.append(ingredientObj)
            }else if array.count == 3 {
                let ingredientObj = IngredientModel(amount: array[0], unit: array[1], name: array[2])
                ingredientsObjects.append(ingredientObj)

            }
    }
}
    //Verify if ingredients already exist by checking both shopping list and completed otherwise add.
    func addIngredients() {
        
        for ingredient in ingredientList {
            array = ingredient.components(separatedBy: " ")
            if array.count < 3 {
                let ingredientObj = IngredientModel(amount: " ", unit: " ", name: array[0])
                if !(ingredientsObjects.contains(ingredientObj) || completedIngredients.contains(ingredientObj) ){
                    ingredientsObjects.append(ingredientObj)
                }else {
                    print("Ingredient: \(ingredient) Already exists!")
                }
                
            }else if array.count == 3 {
                let ingredientObj = IngredientModel(amount: array[0], unit: array[1], name: array[2])
                if !(ingredientsObjects.contains(ingredientObj) || completedIngredients.contains(ingredientObj) ){
                    ingredientsObjects.append(ingredientObj)
                }else {
                    print("Ingredient: \(ingredient) Already exists!")
                }
                
            }
        }
    }
    //Checks to find out which ingredients need to be deleted.
    func removeIngredients() {
        
        print("Inside removeIngredients")
        var shoppingCartCount = Array(repeating: 0, count: ingredientsObjects.count)
        var completedCount = Array(repeating: 0, count: completedIngredients.count)
        print("IngredientList = \(ingredientList)")
        for ingredient in ingredientList {
            
            array = ingredient.components(separatedBy: " ")
            if array.count < 3 {
                let ingredientObj = IngredientModel(amount: " ", unit: " ", name: array[0])
                if ingredientsObjects.contains(ingredientObj){
                    shoppingCartCount[ingredientsObjects.index(of: ingredientObj)!] = 1
                    print("Ingredient name: \(ingredientObj.name) exists in shopping cart. Adding 1. \(shoppingCartCount)")
                }else if completedIngredients.contains(ingredientObj) {
                    completedCount[ingredientsObjects.index(of: ingredientObj)!] = 1
                    print("Ingredient name: \(ingredientObj.name) exists in completed cart. Adding 1. \(completedCount)")
                }
                
            }else if array.count == 3 {
                let ingredientObj = IngredientModel(amount: array[0], unit: array[1], name: array[2])
                if ingredientsObjects.contains(ingredientObj){
                    shoppingCartCount[ingredientsObjects.index(of: ingredientObj)!] = 1
                    print("Ingredient name: \(ingredientObj.name) exists in shopping cart. Adding 1. \(shoppingCartCount)")
                }else if completedIngredients.contains(ingredientObj) {
                    completedCount[ingredientsObjects.index(of: ingredientObj)!] = 1
                    print("Ingredient name: \(ingredientObj.name) exists in completed cart. Adding 1. \(completedCount)")
                }
                
            }
            
        }
        print("Shopping cart count = \(shoppingCartCount)")
        print("Completed cart count = \(completedCount)")
        print(ingredientsObjects)
        print(completedIngredients)
        
        //removeCount is used to keep track of how many items have been removed in the Object array (ingredient & completed). This is needed because as we remove items the array shrinks and the index from shoppingCartCount is no longer accurate for removal unless we take in for account the amount of items we've deleted.
        for (index,element) in shoppingCartCount.enumerated() {
            if element == 0 {
                print("Deleting item at index :\(index)")
                ingredientsObjects.remove(at: (index - removeCount))
                removeCount += 1
                print(ingredientsObjects)
                print(shoppingCartCount)

            }
        }
        
        removeCount = 0
        
        for (index,element) in completedCount.enumerated() {
            if element == 0 {
                print("Deleting item at index: \(index)")
                completedIngredients.remove(at: (index - removeCount))
                removeCount += 1
            }
        }
        
        removeCount = 0
    }

    
    
    //MARK: StateArray keep track of the operations performed on the other tab bar controllers. If an add or remove operation was performed the appropriate function get's called.
    func stateChange() {
        print("inside statechange")
        loadIngredients()
        if let stateArray = userDefaults.stringArray(forKey: "operation"){
            print("state array = \(stateArray)")
            if stateArray.contains("add"){
                addIngredients()
            }
            if stateArray.contains("remove"){
                removeIngredients()
            }
            
            userDefaults.set(localArray, forKey: "operation")
        }
        saveData("shopping")
        saveData("completed")
        tableView.reloadData()
        userDefaults.set(false, forKey: "state")
    }
    

}
