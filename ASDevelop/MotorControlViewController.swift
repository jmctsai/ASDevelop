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
    
    // Pointer is an object which extends UIImageView to be drag and dropable
    var PointerObject: ObjectView!
    var TargetImage: UIImageView!
    
    // Setup for question time limit
    var timer: Timer?
    var secondsLeft = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prepare sounds
        do {
            correctSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "positive", ofType: "wav")!))
            correctSound?.prepareToPlay()
            correctSound?.volume = instructor.volume
            
            incorrectSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "negative", ofType: "wav")!))
            incorrectSound?.prepareToPlay()
            incorrectSound?.volume = instructor.volume
        } catch {
            print(error)
        }
        
        ProgressField.isUserInteractionEnabled = false
        
        // Draw the target image to the screen
        var frameDoor = CGRect(x: 100, y: 100, width: 92, height: 92)
        TargetImage = UIImageView(frame: frameDoor)
        TargetImage.image = UIImage(named: "MotorTarget")
        self.view.addSubview(TargetImage)
        
        // Draw the pointer image to the screen
        frameDoor = CGRect(x: 100, y: 100, width: 75, height: 84)
        PointerObject = ObjectView(frame: frameDoor)
        PointerObject.image = UIImage(named: "MotorPointer")
        PointerObject.contentMode = .scaleAspectFit
        PointerObject.isUserInteractionEnabled = true
        self.view.addSubview(PointerObject)
        
        // Start the first question
        currentQuestion = 1
        nextQuestion()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuestion() {
        // Update the current question number on screen
        ProgressField.text = String(currentQuestion)
        
        // Move pointer and target to random location on screen
        let randomXPointer = arc4random_uniform(910) + 30;
        let randomYPointer = arc4random_uniform(660) + 30;
        
        var randomXTarget = arc4random_uniform(910) + 30;
        var randomYTarget = arc4random_uniform(660) + 30;
        
        // If the target is too close to the pointer generate new target location
        while( abs(Int(randomXTarget) - Int(randomXPointer)) < 400 && abs(Int(randomYTarget) - Int(randomYPointer)) < 400) {
            randomXTarget = arc4random_uniform(910) + 30;
            randomYTarget = arc4random_uniform(660) + 30;
        }
        
        // Set the pointer and target locations
        PointerObject.frame.origin.x = CGFloat(randomXPointer)
        PointerObject.frame.origin.y = CGFloat(randomYPointer)
        
        TargetImage.frame.origin.x = CGFloat(randomXTarget)
        TargetImage.frame.origin.y = CGFloat(randomYTarget)
        
        // Begin time limit
        secondsLeft = 10.0
        runTimer()
    }

    // When a question is answered or times out
    func doneQuestion(correct: Bool) {
        
        // Delete the pointer to stop user interaction
        PointerObject.removeFromSuperview()
        
        // Stop the timer countdown
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        // If correct xp is gained
        if correct {
            xpGained = xpGained + 1
            correctSound?.play()
        }
        else {
            incorrectSound?.play()
        }
        
        // Wait for sound to finish playing, 0.6s
        usleep(600000)
        
        // Add the pointer back to the view
        self.view.addSubview(PointerObject)
        
        currentQuestion = currentQuestion + 1
        
        // If not end of quiz go on to next question
        if currentQuestion <= 10 {
            nextQuestion()
        }
        else {
            // End of the quiz
            quizFinish()
        }

    }
    
    // Begin a timer which will be checked every 0.1s
    func runTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    // Timer that counts down and checks whether the pointer is within the bounds of the target, every 0.1s
    @objc func updateTimer() {
        secondsLeft = secondsLeft - 0.1
        
        if TargetImage.frame.midX < PointerObject.frame.maxX && TargetImage.frame.midX > PointerObject.frame.minX && TargetImage.frame.midY < PointerObject.frame.maxY && TargetImage.frame.midY > PointerObject.frame.minY {
            doneQuestion(correct: true)
        }
        
        if secondsLeft <= 0.0 {
            doneQuestion(correct: false)
        }
    }
    
    // When the quiz is done
    func quizFinish() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        // Show the quiz results screen
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
