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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealTableView.delegate = self
        mealTableView.dataSource = self
        orderedRecipes = loadOrderedRecipe()
//        loadData(orderedString)
//        initializeNumRows()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        loadData(recipeString)
        loadData(orderedString)
        print("Ordered String - \(orderedRecipes)")
        for recipe in selectedMeals {
            if recipe.added == false {
                let selectedDay = days.index(of: recipe.dayofWeek)!
                print(" In recipe added: \(numberOfRowsinSection)")
                orderedRecipes[selectedDay].remove(at: numberOfRowsinSection[selectedDay])
                orderedRecipes[selectedDay].insert(recipe, at: numberOfRowsinSection[selectedDay])
                numberOfRowsinSection[selectedDay] += 1
                recipe.added = true
            }
            encodeData(recipeString)
            encodeData(orderedString)
            mealTableView.reloadData()
            print(numberOfRowsinSection)
        }
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
    
    
    //MARK : Data manipulation methods
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
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
        } else {
            if let data = try? Data(contentsOf: orderedURL!){
                let decoder = PropertyListDecoder()
                do {
                    numberOfRowsinSection = try decoder.decode([Int].self, from: data)
                }catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    
    
    //Allows the orderedRecipes array to pull in all recipes in the PLIST when the app is opened after being killed
    //BUG FIX: Crashing because there are 4 recipes on tuesday and only 3 values instanstiated in the 2d array (referencing an index out of range) Need to prevent adding more then 3 recipes to a day. -- FIXED
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


}
