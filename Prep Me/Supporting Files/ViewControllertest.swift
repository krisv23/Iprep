//
//  ViewControllertest.swift
//  Prep Me
//
//  Created by Kristopher Valas on 12/4/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewControllertest: UIViewController {

    @IBOutlet weak var ingredientTextField: UITextField!
    let header = ["hidden" :"hidden",
                  "hidden" : "hidden"]
    let url =  "hidden"
    let servings : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Text Field Methods
    /****************************************/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ingredientTextField.text != nil{
            fireMessage()
        }else{
            print("No text!")
        }
    }
    
    //MARK : Networking
    /****************************************/
    func fireMessage(){
        let parameters : [String : String] = ["ingredientList" : ingredientTextField.text!, "servings" : "\(servings)"]
        Alamofire.request(url, method: .post, parameters: parameters, headers: header).responseJSON {
            response in
            if response.result.isSuccess{
                let ingredientJSON : JSON = JSON(response.result.value!)
                self.parseJSON(message: ingredientJSON)
            }else{
                print(response.result.error!)
            }
        }
    }
    
    
    //MARK : Parse JSON
    /****************************************/
    
    func parseJSON(message : JSON){
        
        let amount = message[0]["amount"].intValue
        let unit = message[0]["unitShort"].stringValue
        print(amount)
        print(unit)
    }

}
