//
//  RecipesViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 11/20/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let FoodCategory = ["Breakfast", "Poultry", "Beef", "Seafood", "Pasta", "Soups and Sides", "Salads"]
    var category = ""

    @IBOutlet weak var RecipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecipesTableView.delegate = self
        RecipesTableView.dataSource = self
        
        let categoryDB = Database.database().reference().child("category")
        let recipeDB = Database.database().reference().child("recipe")
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Table Data
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FoodCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
        cell.textLabel?.text = FoodCategory[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       category = FoodCategory[indexPath.row]
       tableView.deselectRow(at: indexPath, animated: true)
       performSegue(withIdentifier: "specificCategory", sender: self)
    }
    
    
    // MARK : Prepare for new screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SpecificCategoryViewController{
            destinationVC.category = category
        }
    }

        
//        var message = ""
//        switch indexPath.row {
//       //Breakfast
//        case 0:
//            message = "Breakfast selected!"
//      //
//        case 1:
//            message = "Chicken selected!"
//        case 2:
//            message = "Beef selected!"
//        case 3:
//            message = "fish selected!"
//        case 4:
//            message = "pasta selected!"
//        default:
//            break;
//        }
        
        //Debugging tableview selection
//        var alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    
    
}
