//
//  NewStudentViewController.swift
//  ASDevelop
//
//  Created by lmulder on 11/5/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewStudentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var AddAPhotoButton: UIButton!
    var InstructorClassroomViewController:InstructorClassroomViewController?
    var studentPhoto:UIImage?
    
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

    @IBAction func backButtonTapped(_ sender: Any) {
        //Close the view
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: Any) {
        
        // Hide the keyboard.
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = LandscapeUIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        studentPhoto = createStudentImage(image: selectedImage)
        AddAPhotoButton.setImage(createNewImage(image: selectedImage), for: .normal)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
 
    //REGISTER BUTTON TAPPED
    @IBAction func newStudentButtonTapped(_ sender: Any){
        
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let ageText = ageTextField.text
        let age: Int? = Int(ageTextField.text!)
        
        //Check for empty fields
        if(firstName == "" || lastName == "" || ageText == "")
        {
            displayMyAlertMessage(userMessage: "All fields are required")
            return
        }
        
        //Check that age is a number
        if age == nil {
            displayMyAlertMessage(userMessage: "Age must be a number")
            return
        }
        
        if studentPhoto == nil {
            displayMyAlertMessage(userMessage: "Must provide a photo")
            return
        }
        
        //Create new student class
        let student = Student(modules: [Module](), firstName: firstName!, age: age!, photo: studentPhoto)
        
        //Pass student class to logged in module
        instructor.students.append(student)
        
        //Go back to student module
        dismiss(animated: true, completion: nil)
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

func createStudentImage(image: UIImage) -> UIImage {
    let bottomImage = UIImage(named: "ImageBase.png")!
    let topMask = UIImage(named: "StudentMask.png")!
    let studentImage = image
    
    let newSize = CGSize(width:383, height:261) // set this to what you need
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    
    studentImage.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width:383, height:227)))
    bottomImage.draw(in: CGRect(origin: CGPoint(x: 0,y :227), size: CGSize(width:383, height:34)))
    topMask.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width:383, height:14)))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

func createNewImage(image: UIImage) -> UIImage {
    let bottomImage = UIImage(named: "AddPhoto.png")!
    let topMask = UIImage(named: "StudentMask.png")!
    let topImage = image
    
    let newSize = CGSize(width:337, height:230) // set this to what you need
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    
    bottomImage.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width:337, height:230)))
    topImage.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width:337, height:199)))
    topMask.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width:337, height:12)))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
