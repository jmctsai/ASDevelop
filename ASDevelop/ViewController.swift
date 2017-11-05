//
//  ViewController.swift
//  ASDevelop
//
//  Created by Johnny Tsai on 10/27/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        self.passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //SIGN IN BUTTON TAPPED
    func textFieldShouldReturn(_ passwordTextField: UITextField) -> Bool {
        //check if field populated
        passwordTextField.resignFirstResponder()
        if let userEmail = emailTextField.text, let userPassword = passwordTextField.text {
            Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: { (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.displayMyAlertMessage(userMessage: "Login Failed.. Please Try Again")
                }
                //present login screen after successfully logged in
                self.presentLoggedInScreen()
            })
        }
        return true
    }
    
    //FORGOT YOUR PASSWORD TAPPED
    @IBAction func passwordRecovery(_ sender: Any) {
        let userEmail = emailTextField.text!
        Auth.auth().sendPasswordReset(withEmail:userEmail) { (error) in
            if error != nil
            {
                // Error - Unidentified Email
                self.displayMyAlertMessage(userMessage: "No account exists with this email address. Please try another email address.")
                return
            }
            else
            {
                // Success - Sent recovery email
                self.displayMyAlertMessage(userMessage: "Password reset email sent successfully!")
                return
            }
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
    
    //present login screen after successfully logged in
    func presentLoggedInScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let loggedInViewController:loggedInViewController = storyboard.instantiateViewController(withIdentifier: "loggedInViewController") as! loggedInViewController
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    
}

