//
//  ViewController.swift
//  ASDevelop
//
//  Created by Johnny Tsai on 10/27/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainLoginViewController: UIViewController, UITextFieldDelegate {

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
    
    //Initialize the new instructor class
    func initializeInstructor() {
        
        instructor = Instructor()
        
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
                
                //Parse Json and apply attributes to instructor class
                instructor.email = userEmail
                
                //present login screen after successfully logged in
                self.presentInstructorClassroomScreen()
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
    func presentInstructorClassroomScreen(){
        
        //Create the new view
        let InstructorClassroomViewController:InstructorClassroomViewController = storyboard!.instantiateViewController(withIdentifier: "InstructorClassroomViewController") as! InstructorClassroomViewController
        
        //Assign the instructor class to the new logged in view
        InstructorClassroomViewController.MainLoginViewController = self
        
        //Change the view to the new view
        self.present(InstructorClassroomViewController, animated: true, completion: nil)
        
    }
    
}

