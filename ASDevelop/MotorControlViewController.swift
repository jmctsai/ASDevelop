//
//  MotorControlViewController.swift
//  ASDevelop
//
//  Created by lmulder on 11/26/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import AVFoundation

class MotorControlViewController: UIViewController, AVAudioPlayerDelegate {
    
    var studentIndex = 0
    var moduleIndex = 0
    
    var correctSound:AVAudioPlayer?
    var incorrectSound:AVAudioPlayer?
    
    @IBOutlet weak var TargetImage: UIImageView!
    
    @IBOutlet weak var ProgressField: UITextField!
    
    var currentQuestion = 1
    var xpGained = 0
    
    var PointerObject: ObjectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressField.isUserInteractionEnabled = false
        
        let frameDoor = CGRect(x: 100, y: 100, width: 75, height: 84)
        PointerObject = ObjectView(frame: frameDoor)
        PointerObject.image = UIImage(named: "MotorPointer")
        PointerObject.contentMode = .scaleAspectFit
        PointerObject.isUserInteractionEnabled = true
        self.view.addSubview(PointerObject)
        
        currentQuestion = 1
        nextQuestion()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuestion() {
        ProgressField.text = String(currentQuestion)
        
        let randomXPointer = arc4random_uniform(950) + 10;
        let randomYPointer = arc4random_uniform(690) + 10;
        
        var randomXTarget = arc4random_uniform(950) + 10;
        var randomYTarget = arc4random_uniform(690) + 10;
        
        while( abs(Int(randomXTarget) - Int(randomXPointer)) < 200 && abs(Int(randomYTarget) - Int(randomYPointer)) < 200) {
            randomXTarget = arc4random_uniform(950) + 10;
            randomYTarget = arc4random_uniform(690) + 10;
        }
        
        PointerObject.frame = CGRect(x: CGFloat(randomXPointer), y: CGFloat(randomYPointer), width: PointerObject.frame.size.width, height: PointerObject.frame.size.height)
        
        TargetImage.frame = CGRect(x: CGFloat(randomXTarget), y: CGFloat(randomYTarget), width: TargetImage.frame.size.width, height: TargetImage.frame.size.height)
        
        currentQuestion = currentQuestion + 1
        
        xpGained = xpGained + 1
        
        if currentQuestion > 10 {
            quizFinish()
        }
    }
    
    func quizFinish() {
        presentModuleFinishScreen(xpGained: xpGained)
    }
    
    //present login screen after successfully logged in
    func presentModuleFinishScreen(xpGained: Int) {
        
        //Create the new view
        let ModuleFinishViewController:ModuleFinishViewController = storyboard!.instantiateViewController(withIdentifier: "NewModuleFinishViewController") as! ModuleFinishViewController
        
        //Assign the instructor class to the new logged in view
        ModuleFinishViewController.moduleIndex = moduleIndex
        ModuleFinishViewController.studentIndex = studentIndex
        ModuleFinishViewController.xpGained = xpGained
        ModuleFinishViewController.MotorControlViewController = self
        
        //Change the view to the new view
        self.present(ModuleFinishViewController, animated: true, completion: nil)
    }
}
