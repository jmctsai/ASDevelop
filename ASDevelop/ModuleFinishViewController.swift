//
//  ModuleFinishViewController.swift
//  ASDevelop
//
//  Created by lmulder on 2017-11-08.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ModuleFinishViewController: UIViewController {
    
    var moduleIndex = 0
    var studentIndex = 0
    var ModuleStartViewController:ModuleStartViewController?
    var EmotionRecognitionViewController:EmotionRecognitionViewController?
    var VisualPerceptionViewController:VisualPerceptionViewController?
    var xpGained = 0
    
    @IBOutlet weak var XPProgressBar: UIImageView!
    @IBOutlet weak var LevelField: UITextField!
    @IBOutlet weak var ModuleNameField: UITextField!
    @IBOutlet weak var XPGainedField: UITextField!
    @IBOutlet weak var XPCurrentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadValues() {
        XPGainedField.text = "+" + String(xpGained) + " xp"
        LevelField.text = "Level " + String(instructor.students[studentIndex].modules[moduleIndex].level)
        ModuleNameField.text = instructor.students[studentIndex].modules[moduleIndex].name
        XPProgressBar.frame = CGRect(x: 224, y: 156, width: Int(564.0 * Double(instructor.students[studentIndex].modules[moduleIndex].xp) / 100.0), height: Int(XPProgressBar.frame.height))
        XPProgressBar.image = createProgressBar(hexBGColor: "1029AF", hexFGColor: "1F82E7", width: Int(564.0 * Double(instructor.students[studentIndex].modules[moduleIndex].xp) / 100.0), height: Int(XPProgressBar.frame.height), xp: Int(100.0 * Double(instructor.students[studentIndex].modules[moduleIndex].xp - xpGained) / Double(instructor.students[studentIndex].modules[moduleIndex].xp)))
        XPCurrentField.text = "\(instructor.students[studentIndex].modules[moduleIndex].xp)/100 xp"
        
        
        
        //s==============STORE GAME DATA name, level, exp==================
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        let gameReference = ref.child("Instructors").child(userID).child("Student").child("\(instructor.students[studentIndex].studentID)").child("Modules").child("\(instructor.students[studentIndex].gameID)")

        print("xp is stored under this ID: \(gameReference.key)")
        
        // need to move this under the specfic game node
        let gameNode = ["Xp": instructor.students[studentIndex].modules[moduleIndex].xp,
                        "Level": instructor.students[studentIndex].modules[moduleIndex].level]
        gameReference.updateChildValues(gameNode, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
                print("Saved game information successfully into Firebase DB")
            })
        
        ///////////////////////////////////////////////////////////////////////////////
        
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        //Go back to the module start screen
        performSegue(withIdentifier: "unwindSegueToModuleStart", sender: self)
    }
    
    @IBAction func backToModulesButtonTapped(_ sender: UIButton) {
        //Go back to the modules screen
        performSegue(withIdentifier: "unwindSegueToStudentModules", sender: self)
    }
    
}

