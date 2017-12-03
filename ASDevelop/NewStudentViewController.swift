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

class NewStudentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var AddAPhotoButton: UIButton!
    var InstructorClassroomViewController:InstructorClassroomViewController?
    var studentPhoto:UIImage?
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
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
    
    /////////////////////--------------------------
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = LandscapeUIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title:"Photo Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
               print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction) in }))
        
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)

        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        studentPhoto = createStudentImage(image: image)
        AddAPhotoButton.setImage(createNewImage(image: image), for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
            print("Saved student data, F.Name, L.Name, Age successfully into Firebase DB")
        })
        
        // ID of current STUDENT
        let currentStudentID = usersReference.key
        print("current Student ID is : \(currentStudentID)")

        //Create new student class
        let student = Student(modules: [Module](), firstName: firstName!, age: age!, photo: studentPhoto, studentID: currentStudentID)
        
        //////////////////////////////////////////////////////////////////////
        //==== STORING OF USER IMAGE =======
        
        // Get a reference to the loaction where we'll store our photos
        let photosRef = Storage.storage().reference().child("student_photos")

        // Get a reference to store the file at student_photos/<FILENAME>
        //let photoRef = photosRef.child("\(NSUUID().uuidString).png")
        let photoRef = photosRef.child("\(currentStudentID).png")
        
        // Upload student photo to Firebase Storage
        if let uploadData = UIImagePNGRepresentation(studentPhoto!) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            photoRef.putData(uploadData, metadata: metadata).observe(.success) { (snapshot) in
                //When the image has successfully uploaded, we get it's download URL
                let downloadURL = snapshot.metadata?.downloadURL()?.absoluteString
                //print(downloadURL)  //https://firebasestorage.googleapis.com/v0/b/asdevelop-group03.appspot.com/o/student_photos%2FD4DEA135-12A2-4EAD-9324-5E0A15C75759.png?alt=media&token=93a3a804-19cf-4626-9520-f072cf353c6a
                
                //Update Student with their profile image URL location
                let studentReference = ref.child("Instructors").child(userID).child("Student").child(currentStudentID)
                let value = ["profileImageURL": downloadURL]
                studentReference.updateChildValues(value, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                    print("Saved profile image successfully into Firebase DB")
                })
            }
        }
        ///////////////////////////////////////////////////////////////////////
        
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

// Set photoImageView to display the selected image.
//studentPhoto = createStudentImage(image: selectedImage)
//AddAPhotoButton.setImage(createNewImage(image: selectedImage), for: .normal)
