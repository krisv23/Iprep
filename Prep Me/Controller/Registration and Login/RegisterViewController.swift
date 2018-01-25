//
//  RegisterViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 11/4/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import UIKit
import Firebase


class RegisterViewController: UIViewController {

   //Outlet variables
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerPushed(_ sender: Any) {
        
        //Verify no empty fields exist
        if(firstName.text == "" || lastName.text == "")
        {
            displayError(error: "Please make sure all fields are filled in.")
        }
        else
        {
                let displayName = firstName.text! + " " + lastName.text!
                Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                
                    if(error != nil)
                    {
                        print(error?.localizedDescription)
                        self.displayError(error: (error?.localizedDescription)!)
                    }
                    else
                    {
                        let request = user?.createProfileChangeRequest()
                        request?.displayName = displayName
                        request?.commitChanges(completion: { (error) in
                            
                            if error != nil {
                                self.displayError(error: (error?.localizedDescription)!)
                            }else{
                                self.performSegue(withIdentifier: "goToHome", sender: self)
                            }
                        })
                        
                    }
            })
        }
        
    
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - Error Functions

    func displayError(error : String){
        
        let alertController = UIAlertController(title: "Error:", message: error, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}
