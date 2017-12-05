//
//  AccountSettingsViewController.swift
//  ASDevelop
//
//  Created by Amitoj Singh Gill on 2017-11-15.
//  Copyright Â© 2017 CMPT275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountSettingsViewController: UIViewController {
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Change the volume slider to the current value
        volumeSlider.value = instructor.volume
        
        email.borderStyle = UITextBorderStyle.roundedRect
        password.borderStyle = UITextBorderStyle.roundedRect
        currentPassword.borderStyle = UITextBorderStyle.roundedRect
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // go back to classroom
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var currentPassword: UITextField!
    
    @IBAction func changeSettingsButtonPressed(_ sender: Any) {
        //Save the volume slider value
        instructor.volume = volumeSlider.value

        //update email and password
        verifyEmailPasswordandUpdate()
        
        // go back to classroom
        dismiss(animated: true, completion: nil)
    }
    
    func displayMyAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
    }
    
    func verifyEmailPasswordandUpdate(){
        let credential = EmailAuthProvider.credential(withEmail: instructor.email, password: currentPassword.text!)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: {error in
            if let error = error {
                print(error.localizedDescription)
                let alertView = UIAlertView(title: "Login", message: "Login credentials couldnot be verified...Please try again", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
            }
            else{
                //if email and password both are filled
                if(self.email.text != "" && self.password.text != "") {
                    self.updateEmail(userEmail: self.email.text!)
                    self.updatePassword(userPassword: self.password.text!)
                    let alertView = UIAlertView(title: "Update Email and Password", message: "You have successfully updated your Email and Password", delegate: self, cancelButtonTitle: "OK")
                    alertView.show()
                    let ref = Database.database().reference()
                    let userID = Auth.auth().currentUser?.uid
                    let usersReference = ref.child("Instructors").child(userID!)
                    let emailNode = ["Email": self.email.text]
                    usersReference.updateChildValues(emailNode, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                        print("Updated Email successfully into Firebase DB")
                    })
                    instructor.email = self.email.text!
                }
                // if only email field is filled
                else if (self.email.text != "") {
                    self.updateEmail(userEmail: self.email.text!)
                    let alertView = UIAlertView(title: "Update Email", message: "You have successfully updated your Email", delegate: self, cancelButtonTitle: "OK")
                    alertView.show()
                    let ref = Database.database().reference()
                    let userID = Auth.auth().currentUser?.uid
                    let usersReference = ref.child("Instructors").child(userID!)
                    let emailNode = ["Email": self.email.text]
                    usersReference.updateChildValues(emailNode, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                        print("Updated Email successfully into Firebase DB")
                    })
                    instructor.email = self.email.text!
                }
                // if only password field is filled
                else if (self.password.text != "") {
                    self.updatePassword(userPassword: self.password.text!)
                    let alertView = UIAlertView(title: "Update Password", message: "You have successfully updated your Password", delegate: self, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })
    }
    
    func updatePassword(userPassword:String) {
        Auth.auth().currentUser?.updatePassword(to: userPassword, completion: {(error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("Password successfully updated")
            }
        })
    }
    
    func updateEmail(userEmail:String) {
        Auth.auth().currentUser?.updateEmail(to: userEmail, completion: {(error) in
            if let error = error {
                    print(error.localizedDescription)
            }
            else {
                print("Email successfully updated")
            }
        })
    }
}
