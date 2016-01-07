//
//  WelcomeViewController.swift
//  timerTest
//
//  Created by Dylan Sharkey on 11/19/15.
//  Copyright © 2015 Dylan Sharkey. All rights reserved.
//

import UIKit

extension String {
    var length: Int { return characters.count    }  // Swift 2.0
}

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    let user = User.all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if name is set for this device if it is
        //load it to the nameTextField
        if user.count > 0 {
            nameTextField.text = user[0].name
        }
    }
    
    
    @IBAction func beginButtonPressed(sender: UIButton) {
        if nameTextField.text! == "" {
            messageTextLabel.text = "Name field can't be empty!"
        }
        else if nameTextField.text!.length > 10 {
            messageTextLabel.text = "Name can't be more than 10 letters"
            nameTextField.text = ""
        }
        else
        {
            //save the name
            if user.count > 0 {
                user[0].name = nameTextField.text!
                user[0].save()
            }
            else {
                let newUser = User(name: nameTextField.text!)
                newUser.save()
            }
            performSegueWithIdentifier("menuSegue", sender: self)
        }
    }
    
    
}
