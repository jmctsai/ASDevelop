//
//  RegisterPageViewController.swift
//  ASDevelop
//
//  Created by Johnny Tsai on 10/30/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewStudentViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.borderStyle = UITextBorderStyle.roundedRect
        lastNameTextField.borderStyle = UITextBorderStyle.roundedRect
        ageTextField.borderStyle = UITextBorderStyle.roundedRect
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //REGISTER BUTTON TAPPED
    @IBAction func newStudentButtonTapped(_ sender: Any){
        
        let firstName = firstNameTextField.text;
        let lastName = lastNameTextField.text;
        let age = ageTextField.text;
        
        //Check for empty fields
        if(firstName == "" || lastName == "" || age == "")
        {
            displayMyAlertMessage(userMessage: "All fields are required")
            return
        }
        
    }
    
    //display alert msg
    func displayMyAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
    }
}
