//
//  RegisterPageViewController.swift
//  ASDevelop
//
//  Created by Johnny Tsai on 10/30/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterPageViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmailTextField.borderStyle = UITextBorderStyle.roundedRect
        userPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        confirmPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //REGISTER BUTTON TAPPED
    @IBAction func registerButtonTapped(_ sender: Any){
        
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let userConfirmPassword = confirmPasswordTextField.text;
        
        
        //Check for empty fields
        if(userEmail == "" || userPassword == "" || userConfirmPassword == "")
        {
            displayMyAlertMessage(userMessage: "All fields are required")
            return
        }
        
        //Check if passwords match
        if(userPassword != userConfirmPassword)
        {
            displayMyAlertMessage(userMessage: "Password do not match")
            return
        }
        
        if let userEmail = userEmailTextField.text , let userPassword = userPasswordTextField.text {
            Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: { (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    
                    //ERRORS (to be added)
                    //https://firebase.google.com/docs/auth/ios/errors
                    
                    self.displayMyAlertMessage(userMessage: "Registration Failed.. Please Try Again")
                    return
                }
                self.displayMyAlertMessage(userMessage: "You are successfully registered")
                return
            })
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
