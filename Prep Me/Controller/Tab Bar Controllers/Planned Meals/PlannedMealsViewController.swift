//
//  PlannedMealsViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 2/9/18.
//  Copyright © 2018 Kristopher Valas. All rights reserved.
//

import UIKit

class PlannedMealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    

    @IBOutlet weak var mealTableView: UITableView!
    var selectedMeals = [RecipeModel]()
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let numberOfRowsinSection = [2,1,1,1,3,5,8]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealTableView.delegate = self
        mealTableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Tableview datasource/delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsinSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello great test!"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return days[section]
    }

}
