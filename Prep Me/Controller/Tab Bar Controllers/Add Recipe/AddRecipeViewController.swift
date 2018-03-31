//
//  AddRecipeViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 12/1/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import SVProgressHUD


class AddRecipeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {

    
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var instructionsText: UITextView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var leftoverText: UITextView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var caloriesText: UITextField!
    @IBOutlet weak var servingsText: UITextField!
    
    
    
    var ingredientList = [String]()
    var categories = ["Breakfast", "Poultry", "Beef", "Seafood", "Pasta", "Soups and Sides", "Salads"]
    var selectedCategory = "Breakfast"
    var nameCount = 0
 
    let userDefaults = UserDefaults.standard
    var refRecipe : DatabaseReference?
    var refCategory : DatabaseReference?
    var rootRef : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        
        rootRef = Database.database().reference()
        refCategory = rootRef?.child("category")
        refRecipe = rootRef?.child("recipe")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK : Alert Controller
    /****************************************/
    
    @IBAction func addPushed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Ingredients", message: nil, preferredStyle: .alert)
        alertController.addTextField { (fieldIngredient) in
            fieldIngredient.placeholder = "Enter Ingredient"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let ingredient = alertController.textFields?.first?.text
            else{ return }
           
            if ingredient != ""{
                self.addIngredient(ingredient)
            }
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK : Add Ingredient
    
    func addIngredient(_ ingredient : String){
        let index = 0
        ingredientList.insert(ingredient, at: index)
        print(ingredientList)
        let indexPath = IndexPath(row: index, section: 0)
        ingredientTable.insertRows(at: [indexPath], with: .left)
    }
    
    
    @IBAction func cancelPushed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
   
    @IBAction func submitPushed(_ sender: UIButton) {
        
        if let number = nameField.text?.count {
            nameCount = number
        }
        if ingredientList.isEmpty {
            alert(message: "No ingredients in list!")
        }else if nameField.text == nil{
            alert(message: "Please enter a recipe name!")
        }else if nameCount > 27 {
            alert(message: "The recipe name is to long! Please shorten below 25 characters.")
        }else {
            SVProgressHUD.show()
            AddData(_recipeName: nameField.text!)
            SVProgressHUD.dismiss()
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func alert(message : String) {
        
        let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    //MARK : Database Added
    func AddData(_recipeName : String) {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let ChildRf = refCategory?.child("\(selectedCategory)").childByAutoId()
            let key = (ChildRf?.key)!
            ChildRf?.child("name").setValue(_recipeName)
            ChildRf?.child("createdUserID").setValue(uid)
            refRecipe?.child("\(key)/ingredients").setValue(ingredientList)
            refRecipe?.child("\(key)/instructions").setValue(instructionsText.text)
            refRecipe?.child("\(key)/leftovers").setValue(leftoverText.text)
            if let calories = caloriesText.text {
                refRecipe?.child("\(key)/calories").setValue(calories)
            }
            if let servings = servingsText.text {
                refRecipe?.child("\(key)/servings").setValue(servings)
            }
            
        }
        
        
        
        
    }


}

//MARK : Tableview data
/****************************************/
extension AddRecipeViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = ingredientList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        ingredientList.remove(at: indexPath.row)
        ingredientTable.deleteRows(at: [indexPath], with: .left)
        
    }
    
}

//MARK : Picker View
/****************************************/
extension AddRecipeViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
    }
    
    
    //MARK: Text Field methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
}









