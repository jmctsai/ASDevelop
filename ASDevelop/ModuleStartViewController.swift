//
//  ModuleStartViewController.swift
//  ASDevelop
//
//  Created by lmulder on 11/6/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth

class ModuleStartViewController: UIViewController {
    
    @IBOutlet weak var ModuleStartField: UILabel!
    @IBOutlet weak var ModuleStartPhoto: UIImageView!
    @IBOutlet weak var ModuleProgressBar: UIImageView!
    @IBOutlet weak var ModuleStartButton: UIButton!
    @IBOutlet weak var ModuleLevelField: UITextField!
    @IBOutlet weak var ModuleXPField: UITextField!
    
    var studentModulesViewController:StudentModulesViewController?
    var moduleIndex = 0
    var studentIndex = 0
    var xpGained = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadValues()
    }
    
    func reloadValues() {
        ModuleStartField.text = instructor.students[studentIndex].modules[moduleIndex].name
        ModuleStartPhoto.image = instructor.students[studentIndex].modules[moduleIndex].startPhoto
        ModuleProgressBar.image = createProgressBar(hexBGColor: "1F62E7", hexFGColor: "1747BB", width: 343, height: 45, xp: (instructor.students[studentIndex].modules[moduleIndex].xp))
        ModuleLevelField.text = "Level \(instructor.students[studentIndex].modules[moduleIndex].level)"
        ModuleXPField.text = "\(instructor.students[studentIndex].modules[moduleIndex].xp)/100 xp"
        ModuleXPField.frame.origin.x = ModuleProgressBar.frame.origin.x + ModuleProgressBar.frame.size.width + 10
        ModuleXPField.frame.origin.y = ModuleProgressBar.frame.origin.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        // Only if module is Emotion Identification
        if instructor.students[studentIndex].modules[moduleIndex].name == GlobalModules.names[0] {
            presentEmotionRecognitionScreen()
        }
        else if instructor.students[studentIndex].modules[moduleIndex].name == GlobalModules.names[1] {
            presentVisualPerceptionScreen()
        }
        else if instructor.students[studentIndex].modules[moduleIndex].name == GlobalModules.names[2] {
            presentMotorControlScreen()
        }
    }
    
    @IBAction func unwindToModuleStart(segue: UIStoryboardSegue) {
        
    }
    
    //present login screen after successfully logged in
    func presentEmotionRecognitionScreen() {
        
        //Create the new view
        let EmotionRecognitionViewController:EmotionRecognitionViewController = storyboard!.instantiateViewController(withIdentifier: "NewEmotionRecognitionViewController") as! EmotionRecognitionViewController
        
        //Assign the instructor class to the new logged in view
        EmotionRecognitionViewController.studentIndex = studentIndex
        EmotionRecognitionViewController.moduleIndex = moduleIndex
        
        
        //Change the view to the new view
        self.present(EmotionRecognitionViewController, animated: true, completion: nil)
    }
    
    // Present the Visual Perception Game
    func presentVisualPerceptionScreen(){
        
        //Create the new view
        let VisualPerceptionViewController:VisualPerceptionViewController = storyboard!.instantiateViewController(withIdentifier: "NewVisualPerceptionViewController") as! VisualPerceptionViewController
        
        //Assign the instructor class to the new logged in view
        VisualPerceptionViewController.studentIndex = studentIndex
        VisualPerceptionViewController.moduleIndex = moduleIndex
        
        //Change the view to the new view
        self.present(VisualPerceptionViewController, animated: true, completion: nil)
        
    }
    
    // Present the Motor Control Game
    func presentMotorControlScreen(){
        
        //Create the new view
        let MotorControlViewController:MotorControlViewController = storyboard!.instantiateViewController(withIdentifier: "NewMotorControlViewController") as! MotorControlViewController
        
        //Assign the instructor class to the new logged in view
        MotorControlViewController.studentIndex = studentIndex
        MotorControlViewController.moduleIndex = moduleIndex
        
        //Change the view to the new view
        self.present(MotorControlViewController, animated: true, completion: nil)
        
    }
    
}
