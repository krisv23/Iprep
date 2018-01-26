//
//  SpecificCategoryViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 12/29/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import UIKit
import Firebase

class SpecificCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var categoryList: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    //Variables for specific recipe selected
    var category = " "
    var categoryDict = [String : String]()
    var nameArray = [String]()
    var calories = " "
    var ingredients = [String]()
    var leftovers = " "
    var servings = " "
    var instructions = " "
    var name = " "
    var recipeID = " "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryList.delegate = self
        categoryList.dataSource = self
        
        
        //Pulls in the list of recipes from firebase using the selected category.
        let categoryRef = Database.database().reference().child("category/\(category)")
        let user = Auth.auth().currentUser
        categoryLabel.text = category
        if let user = user {
            categoryRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChildren(){
                    for child in (snapshot.value as? NSDictionary)! {
                        if let object = child.value as? [String:AnyObject]{
                            let name = object["name"] as! String
                            self.nameArray.append(name)
                            self.categoryDict["\(name)"] = (child.key as! String)
                            self.recipeID = child.key as! String
                            print(self.nameArray)
                        }
                        
                    }
                    self.categoryList.reloadData()
                }
                
            })
        }

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "names", for: indexPath)
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    //Handles retrieving specific recipe data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ingredients.removeAll()
        if let key = categoryDict[nameArray[indexPath.row]] {
            self.name = nameArray[indexPath.row]
            let recipeRef = Database.database().reference().child("recipe/\(key)")
            recipeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let object = snapshot.value as? [String : AnyObject]
                if let calories = object!["calories"] {
                    self.calories = calories as! String
                }
                if let ingredients = object!["ingredients"] {
                    print("Ingredients list : \(ingredients)")
                    print(type(of: ingredients))
                    for ingredient in ingredients as! NSArray {
                        self.ingredients.append(ingredient as! String)
                    }
                }
                if let serving = object!["servings"] {
                    self.servings = serving as! String
                }
                
                if let leftover = object!["leftovers"] {
                    self.leftovers = leftover as! String
                }
                
                if let instruction = object!["instructions"]{
                    self.instructions = instruction as! String
                }
                
                self.categoryList.deselectRow(at: indexPath, animated: true)
                self.firesegue()
                
            })
        }
        
        
    }
    
    func firesegue() {
        
        performSegue(withIdentifier: "specificRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "specificRecipe"{
            let destinationVC = segue.destination as? SpecificRecipeViewController
            destinationVC?.calories = calories
            destinationVC?.ingredients = ingredients
            destinationVC?.instructions = instructions
            destinationVC?.leftovers = leftovers
            destinationVC?.servings = servings
            destinationVC?.name = name
            destinationVC?.recipeID = recipeID
        }
    }

    @IBAction func backButtonPushed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
