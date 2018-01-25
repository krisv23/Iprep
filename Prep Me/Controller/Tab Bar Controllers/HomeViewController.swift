//
//  HomeViewController.swift
//  Prep Me
//
//  Created by Kristopher Valas on 11/4/17.
//  Copyright © 2017 Kristopher Valas. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

   
    @IBOutlet weak var displayNameText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDisplayName()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setDisplayName() {
        let user = Auth.auth().currentUser
        if let user = user {
            let displayName = user.displayName
            if let displayName = displayName {
                displayNameText.text = "Hello, \(displayName)!"
            }
            
            
        }else {
            displayNameText.text = "Welcome to the IPrep!"
        }
    }


}
