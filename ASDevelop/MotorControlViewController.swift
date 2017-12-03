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
    
    @IBOutlet weak var ProgressField: UITextField!
    
    var currentQuestion = 1
    var xpGained = 0
    
    var PointerObject: ObjectView!
    var TargetImage: UIImageView!
    
    var timer: Timer?
    var secondsLeft = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prepare sounds
        do {
            correctSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "positive", ofType: "wav")!))
            correctSound?.prepareToPlay()
            
            incorrectSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "negative", ofType: "wav")!))
            incorrectSound?.prepareToPlay()
        } catch {
            print(error)
        }
        
        ProgressField.isUserInteractionEnabled = false
        
        var frameDoor = CGRect(x: 100, y: 100, width: 92, height: 92)
        TargetImage = UIImageView(frame: frameDoor)
        TargetImage.image = UIImage(named: "MotorTarget")
        self.view.addSubview(TargetImage)
        
        frameDoor = CGRect(x: 100, y: 100, width: 75, height: 84)
        PointerObject = ObjectView(frame: frameDoor)
        PointerObject.image = UIImage(named: "MotorPointer")
        PointerObject.contentMode = .scaleAspectFit
        PointerObject.isUserInteractionEnabled = true
        self.view.addSubview(PointerObject)
        
        currentQuestion = 1
        nextQuestion()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuestion() {
        ProgressField.text = String(currentQuestion)
        
        let randomXPointer = arc4random_uniform(910) + 30;
        let randomYPointer = arc4random_uniform(660) + 30;
        
        var randomXTarget = arc4random_uniform(910) + 30;
        var randomYTarget = arc4random_uniform(660) + 30;
        
        while( abs(Int(randomXTarget) - Int(randomXPointer)) < 400 && abs(Int(randomYTarget) - Int(randomYPointer)) < 400) {
            randomXTarget = arc4random_uniform(910) + 30;
            randomYTarget = arc4random_uniform(660) + 30;
        }
        
        PointerObject.frame.origin.x = CGFloat(randomXPointer)
        PointerObject.frame.origin.y = CGFloat(randomYPointer)
        
        TargetImage.frame.origin.x = CGFloat(randomXTarget)
        TargetImage.frame.origin.y = CGFloat(randomYTarget)
        
        secondsLeft = 10.0
        runTimer()
    }

    func doneQuestion(correct: Bool) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        if correct {
            xpGained = xpGained + 1
            correctSound?.volume = instructor.volume
            correctSound?.play()
        }
        else {
            incorrectSound?.volume = instructor.volume
            incorrectSound?.play()
        }
        
        // Wait for sound to finish playing, 0.6s
        usleep(600000)
        
        currentQuestion = currentQuestion + 1
        
        if currentQuestion <= 10 {
            nextQuestion()
        }
        else {
            quizFinish()
        }

    }
    
    func runTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimer() {
        secondsLeft = secondsLeft - 0.1
        
        if TargetImage.frame.midX < PointerObject.frame.maxX && TargetImage.frame.midX > PointerObject.frame.minX && TargetImage.frame.midY < PointerObject.frame.maxY && TargetImage.frame.midY > PointerObject.frame.minY {
            doneQuestion(correct: true)
        }
        
        if secondsLeft <= 0.0 {
            doneQuestion(correct: false)
        }
    }
    
    func quizFinish() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        presentModuleFinishScreen(xpGained: xpGained)
    }
    
    //present login screen after successfully logged in
    func presentModuleFinishScreen(xpGained: Int) {
        
        //Create the new view
        let ModuleFinishViewController:ModuleFinishViewController = storyboard!.instantiateViewController(withIdentifier: "NewModuleFinishViewController") as! ModuleFinishViewController
        
        //Assign the instructor class to the new logged in view
        ModuleFinishViewController.moduleIndex = moduleIndex
        ModuleFinishViewController.studentIndex = studentIndex
        ModuleFinishViewController.xpGained = self.xpGained
        ModuleFinishViewController.MotorControlViewController = self
        
        //Change the view to the new view
        self.present(ModuleFinishViewController, animated: true, completion: nil)
    }
}
