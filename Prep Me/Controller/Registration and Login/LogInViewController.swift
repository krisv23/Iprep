//
//  LogInViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 11/4/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Outlet variables
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var rememberMe: UISwitch!
    
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let personalEmail = userDefaults.object(forKey: "email")
        let personalPW = userDefaults.object(forKey: "password")
        
        if let email = personalEmail as? String, let password = personalPW as? String {
            emailText.text = email
            passwordText.text = password
            rememberMe.isOn = true
        }
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valueSwitched(_ sender: UISwitch) {
        if sender.isOn == true{
            userDefaults.set(emailText.text!, forKey: "email")
            userDefaults.set(passwordText.text!, forKey: "password")
            userDefaults.set("true", forKey: "rememberMe")
        }else{
            userDefaults.removeObject(forKey: "email")
            userDefaults.removeObject(forKey: "password")
            userDefaults.removeObject(forKey: "rememberMe")
        }
    }
    
    
    @IBAction func signInTouched(_ sender: Any)
    {
   
        if(emailText.text != " " && passwordText.text != " ")
        {
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                
                if(error != nil)
                {
                    SVProgressHUD.dismiss()
                    print(error?.localizedDescription)
                    self.displayError(error: (error?.localizedDescription)!)
                }else
                {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goToHome2", sender: self)
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
    
    //MARK: Error handler
    func displayError(error : String)
    {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
