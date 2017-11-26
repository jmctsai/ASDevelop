//
//  NewStudentViewController.swift
//  ASDevelop
//
//  Created by lmulder on 11/5/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class NewStudentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var AddAPhotoButton: UIButton!
    var InstructorClassroomViewController:InstructorClassroomViewController?
    var studentPhoto:UIImage?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    var ref: DatabaseReference!
    
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
        
        // Check that a student photo is selected
        if studentPhoto == nil {
            displayMyAlertMessage(userMessage: "Must provide a photo")
            return
        }
        
        //Create new student class
        let student = Student(modules: [Module](), firstName: firstName!, age: age!, photo: studentPhoto)
        
        //Pass student class to logged in module
        instructor.students.append(student)
        
        //Reference current user ID to store into Firebase database
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        let usersReference = ref.child("Instructors").child(userID).child("Student").childByAutoId()
        let studentNode = ["First_Name": firstName,
                      "Last_Name": lastName,
                      "Age": ageText]
        usersReference.updateChildValues(studentNode, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print("Saved student data successfully into Firebase DB")
        })
        
        //////////////////////////////////////////////////////////////////////
        //====STORING OF USER IMAGE=======
        // UID of currently added student
        var currentStudentUID = usersReference.key
        print(currentStudentUID)
        
        // Get a reference to the loaction where we'll store our photos
        let photosRef = Storage.storage().reference().child("student_photos")

        // Get a reference to store the file at student_photos/<FILENAME>
        //let photoRef = photosRef.child("\(NSUUID().uuidString).png")
        let photoRef = photosRef.child("\(currentStudentUID).png")
        
        // Upload student photo to Firebase Storage
        if let uploadData = UIImagePNGRepresentation(studentPhoto!) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            photoRef.putData(uploadData, metadata: metadata).observe(.success) { (snapshot) in
                //When the image has successfully uploaded, we get it's download URL
                let downloadURL = snapshot.metadata?.downloadURL()?.absoluteString
                // ===== Set the download URL to the message box, so that the user can send it to the database
                //self.messageTextField.text = text
                print(metadata)
                //print(downloadURL)  //https://firebasestorage.googleapis.com/v0/b/asdevelop-group03.appspot.com/o/student_photos%2FD4DEA135-12A2-4EAD-9324-5E0A15C75759.png?alt=media&token=93a3a804-19cf-4626-9520-f072cf353c6a
            }
        }
        
        ///////////////////////////////////////////////////////////////////////
        
        
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

// Draws a curved blue base onto the student image provided
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

// Draw a blue base onto the student image for the main profile image
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
