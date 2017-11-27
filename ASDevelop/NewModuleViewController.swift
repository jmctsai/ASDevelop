//
//  NewModuleViewController.swift
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

class NewModuleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var studentModulesViewController:StudentModulesViewController?
    var studentIndex = 0
    var photoArray = [UIImage]()
    var moduleIndexArray = [Int]()
    var selectedModule = -1
    
    @IBOutlet weak var NewModulesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the collection view to be changable by current view
        self.NewModulesCollectionView.delegate = self
        self.NewModulesCollectionView.dataSource = self
        createPhotoArray()
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
        //Choose the module added
        selectedModule = moduleIndexArray[indexPath.row]
        
//////////////////////////////////////////////////////////////////////////////
        // =========== STORING OF USER MODULES ==========
        //"Emotion Identification" = 0
        //"Visual Perception" = 1
        //"Motion Control" = 2
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        let usersReference = ref.child("Instructors").child(userID).child("Student").child("\(instructor.students[studentIndex].id)").child("Modules").childByAutoId()

        let moduleNode = ["Game": selectedModule]
        usersReference.updateChildValues(moduleNode, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print(self.selectedModule)
            print("Saved selected game module successfully into Firebase DB")
        })
///////////////////////////////////////////////////////////////////////////////
        
        //Add the module to the student
        instructor.students[studentIndex].addModule(module: Module(num: selectedModule))
        // Update view
        studentModulesViewController?.updatePhotoArray()
        //Close the view
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //Close the view
        dismiss(animated: true, completion: nil)
    }
    
    func createPhotoArray() {
        var i = 0
        for name in GlobalModules.names {
            var useName = true
            
            for studentModule in instructor.students[studentIndex].modules {
                if studentModule.name == name {
                    useName = false
                }
            }

            if useName {
                photoArray.append(textToImage(drawText: name as NSString, inImage: GlobalModules.modulePhotos[i]!, atPoint: CGPoint(x: 15,y: 235)))
                moduleIndexArray.append(i)
            }
            i = i + 1
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
