//
//  RegisterPageViewController.swift
//  ASDevelop
//
//  Created by Johnny Tsai on 10/30/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterPageViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var ref: DatabaseReference!

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

        //let userName = userNameTextField.text
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userConfirmPassword = confirmPasswordTextField.text

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
                    //"Email already in Use"
                    self.displayMyAlertMessage(userMessage: "Registration Failed.. Please Try Again")
                    return
                }
                
                let ref = Database.database().reference()
                //let userID: String = Auth.auth().currentUser!.uid
                
                guard let uid = user?.uid else{
                    return
                }
                
                let usersReference = ref.child("Instructors").child(uid)
                let instructorNode = ["Email": userEmail]
                usersReference.updateChildValues(instructorNode, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                print("Saved instructors successfully into Firebase DB")
                })
            })
            
            self.displayMyAlertMessage(userMessage: "You are successfully registered")
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

