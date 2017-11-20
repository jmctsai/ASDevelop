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

class InstructorClassroomViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var MainLoginViewController:MainLoginViewController?
    var photoArray = [textToImage(drawText: "+ Add Student", inImage: UIImage(named:"AddButton.png")!, atPoint: CGPoint(x: 15,y: 235))]
    
    @IBOutlet weak var StudentCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StudentCollectionView.delegate = self
        self.StudentCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePhotoArray()
    }
    
    func updatePhotoArray() {
        photoArray.removeAll()
        
        for student in instructor.students {
            let displayImage = student.photo
            let displayText = student.firstName + ", " + String(instructor.students[0].age) as NSString
            photoArray.append(textToImage(drawText: displayText, inImage: displayImage!, atPoint: CGPoint(x: 15,y: 235)))
        }
        
        photoArray.append(textToImage(drawText: "+ Add Student", inImage: UIImage(named:"AddButton.png")!, atPoint: CGPoint(x: 15,y: 235)))
        
        self.StudentCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 383, height: 262))
        imageview.image = photoArray[indexPath.row]
        cell.contentView.addSubview(imageview)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == photoArray.count - 1 {
            presentNewStudentScreen()
        }
        else {
            presentStudentModulesViewController(studentIndex: indexPath.row)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            
            dismiss(animated: true, completion: nil)
            
        } catch {
            print ("There was a problem logging out.. Try again later")
        }
    }
    
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
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
        let AccountSettingsViewController:AccountSettingsViewController = storyboard!.instantiateViewController(withIdentifier: "NewAccountSettingsViewController") as! AccountSettingsViewController
        
        //Change the view to the new view
        self.present(AccountSettingsViewController, animated: true, completion: nil)
    }
}
