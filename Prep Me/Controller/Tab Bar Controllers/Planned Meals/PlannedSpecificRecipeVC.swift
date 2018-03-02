//
//  PlannedSpecificRecipeVC.swift
//  Prep Me
//
//  Created by Kristopher Valas on 2/27/18.
//  Copyright © 2018 Kristopher Valas. All rights reserved.
//

import UIKit

class PlannedSpecificRecipeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Outlets
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var servings: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var ingredientList: UILabel!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var leftovers: UILabel!
    @IBOutlet weak var daysOfWeek: UIPickerView!
    @IBOutlet weak var editBtn: UIButton!
    
    
    //Constants
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let recipeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Recipes.plist")
    let orderedURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Ordered.plist")
    let recipeString = "selectedMeals"
    let orderedString = "orderedArray"
    
    //Variables
    var chosenDish = RecipeModel()
    var numberOfRowsinSection = [0,0,0,0,0,0,0]
    var selectedMeals = [RecipeModel]()
    var selectedDay = 0
    var caloriesText = " "
    var ingredientsText = [String]()
    var ingredientsFormatted = [String]()
    var leftoversText = " "
    var servingsText = " "
    var instructionsText = " "
    var name = " "
    var recipeID = " "
    var newDay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysOfWeek.delegate = self
        daysOfWeek.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData(recipeString)
        loadData(orderedString)
        daysOfWeek.selectRow(selectedDay, inComponent: 0, animated: false)
        daysOfWeek.isUserInteractionEnabled = false
        setLabels()
        formatIngredients()

    }
    
    
    //MARK: Picker View methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return days[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newDay = row
    }
    
    //MARK: Formatted ingredients
    func formatIngredients() {
        ingredientsFormatted.removeAll()
        for string in ingredientsText {
            let formattedString = "\u{2022} \(string) \n"
            ingredientsFormatted.append(formattedString)
        }
        
        ingredientList.text = ingredientsFormatted.joined(separator: "\n")
        ingredientList.sizeToFit()
    }
    
    //Sets text labels of VC
    func setLabels() {
        recipeName.text = chosenDish.recipeName
        servings.text = chosenDish.servings
        instructions.text = chosenDish.instructions
        calories.text = chosenDish.calories
        leftovers.text = chosenDish.leftovers
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
    
    //Work on having new day be saved to the array and make sure its working
    @IBAction func editPressed(_ sender: Any) {
        if editBtn.isSelected {
            editBtn.isSelected = false
            daysOfWeek.isUserInteractionEnabled = false
            editBtn.setTitle("Edit", for: .normal)
            if selectedDay != newDay {
                if numberOfRowsinSection[newDay] == 3 {
                    alertPopUp("Error!", "\(days[newDay]) is already full.")
                    daysOfWeek.selectRow(selectedDay, inComponent: 0, animated: false)
                } else {
                    let index = selectedMeals.index(of: chosenDish)
                    numberOfRowsinSection[selectedDay] -= 1
                    numberOfRowsinSection[newDay] += 1
                    selectedMeals[index!].dayChanged = true
                    selectedMeals[index!].dayofWeek = days[newDay]
                    selectedMeals[index!].row = chosenDish.row
                    selectedMeals[index!].section = chosenDish.section
                    print(selectedMeals[index!].recipeName)
                    print("Section:  \(selectedMeals[index!].section) Row: \(selectedMeals[index!].row)")
                    encodeData(orderedString)
                    encodeData(recipeString)
                }

            }
        }else {
            editBtn.isSelected = true
            editBtn.setTitle("Done", for: .normal)
            daysOfWeek.isUserInteractionEnabled = true
        }

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Alert Message
    func alertPopUp(_ title : String, _ message : String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alert = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertVC.addAction(alert)
        
        self.present(alertVC, animated: true, completion: nil)
    }

}
