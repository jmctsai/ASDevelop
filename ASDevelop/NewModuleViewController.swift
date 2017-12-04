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
    var gameIndex = 0
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

        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
        
        
        // Setting up game ID for finished view module
//        //let gameReference = ref.child("Instructors").child(userID).child("Student").child("\(instructor.students[studentIndex].studentID)").child("Modules").child("\(selectedModule)")
//        let gameReference = ref.child("Instructors").child(userID).child("Student").child("\(instructor.students[studentIndex].studentID)").child("Modules").child("\(selectedModule)")
//
//        // ID of current GAME
//        let currentGameID = gameReference.key
//        print("current Game ID is : \(currentGameID)")
//
//        let moduleNode = ["Game": selectedModule]
//        //usersReference.setValue(moduleNode)
//        gameReference.updateChildValues(moduleNode, withCompletionBlock: { (err, ref) in
//            if err != nil {
//                print(err)
//                return
//            }
//            //module ID
//            //0 = "Emotion Identification"
//            //1 = "Visual Perception"
//            //2 = "Motor Control"
//            print("Selected Game type : \(self.selectedModule)")
//            print("Saved selected game type of 0,1,2 successfully into Firebase DB")
//        })
        
        
        let gameReference = ref.child("Instructors").child(userID).child("Student").child("\(instructor.students[studentIndex].studentID)").child("Modules").child((GlobalModules.names[selectedModule]))
        
        //Initialize Game Module with exp and level of 0 on module creation
        let gameNode = ["Xp": 0,
                        "Level": 0]
        gameReference.updateChildValues(gameNode, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print("Initialize Game Module")
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
