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
    
    
    let recipeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Recipes.plist")

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        loadData()
        loadIngredients()
        tableView.dataSource = self
        tableView.delegate = self
      //  tableView.reloadData()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        loadIngredients()
        tableView.reloadData()
    }

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
    
    //MARK:Load data methods
    func loadData() {
            if let data = try? Data(contentsOf: recipeURL!){
                let decoder = PropertyListDecoder()
                do {
                    selectedMeals = try decoder.decode([RecipeModel].self, from: data)
                }catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
    }
    
    func loadIngredients() {
        
        ingredientList.removeAll()
        for recipe in selectedMeals {
            for ingredient in recipe.ingredients {
                ingredientList.append(ingredient)
                
            }
        }
        initIngredients()
    }
    
    func initIngredients() {
        
        ingredientsObjects.removeAll()
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
}

