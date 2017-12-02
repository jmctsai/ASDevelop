//
//  InstructorClassroomViewController.swift
//  ASDevelop
//
//  Created by lmulder on 11/8/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class InstructorClassroomViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var MainLoginViewController:MainLoginViewController?
    var photoArray = [textToImage(drawText: "+ Add Student", inImage: UIImage(named:"AddButton.png")!, atPoint: CGPoint(x: 15,y: 235))]
    
    @IBOutlet weak var StudentCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow the view controller to automatically update collection view data
        self.StudentCollectionView.delegate = self
        self.StudentCollectionView.dataSource = self

        initializeInstructor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePhotoArray()
    }
    
    // Update the images that are displayed on the collection view
    func updatePhotoArray() {
        // Delete all elements
        photoArray.removeAll()
        
        // Add image of all students to the collection view
        for student in instructor.students {
            let displayImage = student.photo
            let displayText = student.firstName + ", " + String(student.age) as NSString
            photoArray.append(textToImage(drawText: displayText, inImage: displayImage!, atPoint: CGPoint(x: 15,y: 235)))
        }
        
        // Add the Add Student button to collection view
        photoArray.append(textToImage(drawText: "+ Add Student", inImage: UIImage(named:"AddButton.png")!, atPoint: CGPoint(x: 15,y: 235)))
        
        // Refresh the collection view
        self.StudentCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Number of items in the collection view
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get the cell object at current index
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 383, height: 262))
        
        // Assign each photo in the array to the indexed cell
        imageview.image = photoArray[indexPath.row]
        cell.contentView.addSubview(imageview)
        
        // Pass the cell back to the collection view
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // If the last collection view image is pressed
        if indexPath.row == photoArray.count - 1 {
            // Display new student page
            presentNewStudentScreen()
        }
        else {
            // Display the student corresponding to the button number pressed
            presentStudentModulesViewController(studentIndex: indexPath.row)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Initialize the new instructor class
    func initializeInstructor() {
        instructor = Instructor()
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout),with: nil, afterDelay: 0)
        }else{
            let ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            print("Current instructor ID is: \(userID)")
            ref.child("Instructors").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.exists(){
                    print("snapshot does not exist")
                    return
                }
                let instructorData = snapshot.value as! NSDictionary
                
                //INSTRUCTOR EMAIL
                guard let instructorEmail = instructorData["Email"] as! String! else {return}
                instructor.changeEmail(email: instructorEmail)
                print ("\nCurrently logged in Instructor email is: \(instructor.email)")      //instructor1@gmail.com

                //STUDENT
                    ref.child("Instructors").child(userID!).child("Student").observeSingleEvent(of: .value, with: { (snapshot) in
                        if !snapshot.exists(){
                            print("snapshot does not exist")
                            return
                        }
                        print("\nNumber of student's under \(instructorEmail) is: \(snapshot.childrenCount)")
                        let studentData = snapshot.children
                        while let studentInfo = studentData.nextObject() as? DataSnapshot{
                            //STUDENT ID
                            let studentID = studentInfo.key
                            
                            //EACH STUDENNT'S NODE
                            ref.child("Instructors").child(userID!).child("Student").child("\(studentID)").observeSingleEvent(of: .value, with: { (snapshot) in
                                if !snapshot.exists(){
                                    print("snapshot does not exist")
                                    return
                                }
                                let studentDict = snapshot.value as! NSDictionary

                                //AGE,FIRST NAME, PROFILE IMAGE, MODULE
                                ref.child("Instructors").child(userID!).child("Student").child("\(studentID)").child("Modules").observeSingleEvent(of: .value, with: { (snapshot) in
                                    if !snapshot.exists(){
                                        print("snapshot does not exist")
                                        return
                                    }
                                    
                                    //Module Name "Game 0, Game 1, Game 2"
                                    let moduleData = snapshot.children
                                    while let studentModuleInfo = moduleData.nextObject() as? DataSnapshot{
                                        
                                        let moduleName = studentModuleInfo.key

                                        ref.child("Instructors").child(userID!).child("Student").child("\(studentID)").child("Modules").child("\(moduleName)").observeSingleEvent(of: .value, with: { (snapshot) in
                                            if !snapshot.exists(){
                                                print("snapshot does not exist")
                                                return
                                            }
                                            print("\nStudent's ID is: \(studentID)") //Unique Student Auto ID
                                            
                                            //AGE
                                            guard let studentAge = studentDict["Age"] as! String! else {return}
                                            let studentAgeInt = Int(studentAge)
                                            print ("Student's age is: \(studentAgeInt!)")
                                            
                                            //FIRSTNAME
                                            guard let studentFirstName = studentDict["First_Name"] as! String! else {return}
                                            print ("Student's First Name is: \(studentFirstName)")
                                            
                                            //PROFILE IMAGE URL
                                            guard let profileImageURL = studentDict["profileImageURL"] as! String! else {return}
                                            print ("Student's profile image is stored here: \(profileImageURL)")
                                            let storageRef = Storage.storage().reference(forURL: profileImageURL)
                                            storageRef.downloadURL(completion: { (url, error) in
                                                let optData = try? Data(contentsOf: url!)
                                                guard let data = optData else{return}
                                                let profileImage = UIImage(data: data as Data)
                                                
                                            })
                                            
                                            print("Number of modules student with ID: \(studentID) have is: \(snapshot.childrenCount)")
                                            print("Game Name: \(moduleName)")
                                            //0 - emtional recognition
                                            //1 - visual perception
                                            //2 - motor control
                                            
                                            let moduleDict = snapshot.value as! NSDictionary

                                            guard let gameLevel = moduleDict["Level"] as! Int! else {return}
                                            guard let gameXP = moduleDict["Xp"] as! Int! else {return}
                                            print("Level: \(gameLevel)")
                                            print("EXP: \(gameXP)")
                                            let gameLevelInt = Int(gameLevel)
                                            let gameXPInt = Int (gameXP)
                                            
                                            //ADD STUFF TO MODULE ARRAY (maybe not here)
                                            
//VARIABLES OBTAINED FROM FETCHING FROM FIREBASE//////////////////////////////////////////////////////////////////////////////////////////
//                                            Student
//                                                studentAgeInt       //int - age "5"
//                                                studentFirstName    //string - firstName "Bob"
//                                                profileImage        //UIImage - profileImageURL "an image"
//                                            Module
//                                                moduleName          //string - "Game 0"
//                                                gameLevelInt        //int - level "1"
//                                                gameXPInt           //int - xp "60"
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    
                                        }, withCancel: nil)
                                    }
                                }, withCancel: nil)
                                //ADD STUFF TO INSTRUCTOR CLASS (maybe not here)
                                //instructor.addStudent(student: Student(modules: <#T##[Module]#>, firstName: <#T##String#>, age: <#T##Int#>, photo: <#T##UIImage?#>, studentID: <#T##String#>))
                            }, withCancel: nil)
                        }// END OF LOOP iterating through all the students

                    }, withCancel: nil)
                
            }, withCancel: nil)
        }
    }
    
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
    }
    
    
    // Back,Logout button tapped
    @IBAction func logoutTapped(_ sender: Any) {
        
        do {
            // Sign out of firebase
            try Auth.auth().signOut()
            // Close the current view
            dismiss(animated: true, completion: nil)
        } catch {
            print ("There was a problem logging out.. Try again later")
        }
    }
    
    // Settings button pressed
    @IBAction func settingsButtonPressed(_ sender: Any) {
        // Display the account settings page
        presentAccountSettingsViewController()
    }
    
    //present login screen after successfully logged in
    func presentNewStudentScreen() {
        
        //Create the new view
        let NewStudentViewController:NewStudentViewController = storyboard!.instantiateViewController(withIdentifier: "NewStudentViewController") as! NewStudentViewController
        
        //Assign the instructor class to the new logged in view
        NewStudentViewController.InstructorClassroomViewController = self
        
        //Change the view to the new view
        self.present(NewStudentViewController, animated: true, completion: nil)
    }
    
    //present student modules view controller
    func presentStudentModulesViewController(studentIndex: Int) {
        
        //Create the new view
        let StudentModulesViewController:StudentModulesViewController = storyboard!.instantiateViewController(withIdentifier: "NewStudentModulesViewController") as! StudentModulesViewController
        
        //Assign the current view to the parent view
        StudentModulesViewController.InstructorClassroomViewController = self
        
        //Assign the student index to the StudentModulesView
        StudentModulesViewController.studentIndex = studentIndex
        
        //Change the view to the new view
        self.present(StudentModulesViewController, animated: true, completion: nil)
    }
    
    //present settings page
    func presentAccountSettingsViewController() {
        
        //Create the new view
        let AccountSettingsViewController:AccountSettingsViewController = storyboard!.instantiateViewController(withIdentifier: "AccountSettingsViewController") as! AccountSettingsViewController
        
        //Change the view to the new view
        self.present(AccountSettingsViewController, animated: true, completion: nil)
    }
}
