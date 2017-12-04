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
    
    //var timer: Timer?
    //var secondsLeft = 10.0
    
    /*----------------------------*/
    //variables for the count down timer and checkmark
    let cireView = circularTimer.init(frame: CGRect(x:10.0,y:10.0,width : 50.0,height : 50.0))
    var XP = 0 //Xp gained, 2xp if answered correctly in the firsrt 10 seconds, 1xp if answered correctly in the second 10 secs
    var round = 0  //student has two chance, 10 seconds each
    var outOfTime = false  //when outOfTime = true, load next question
    var firstTimerDone = false;
    var stopTimer = false
    var checkmark = true
    /*----------------------------*/
    
    
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
        
        //secondsLeft = 10.0
        //runTimer()
        creatCire()
    }
    
    func doneQuestion(correct: Bool) {
        
        PointerObject.removeFromSuperview()
        
        /* if timer != nil {
         timer?.invalidate()
         timer = nil
         }*/
        
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
        
        self.view.addSubview(PointerObject)
        
        currentQuestion = currentQuestion + 1
        
        if currentQuestion <= 10 {
            nextQuestion()
        }
        else {
            quizFinish()
        }
        
    }
    //create a circular timer
    func creatCire(){
        round = 0
        self.view.addSubview(cireView)
        self.cireView.value = 0
        self.cireView.maximumValue = 100
        self.cireView.backgroundColor = UIColor.clear
        self.cireView.frame = CGRect(x:40, y:40, width:80,height: 80)
        repeatdraw()
    }
    
    //a count down timer that will run twice
    //if user do not response before the second timer finished, then the next question will be loaded
    @objc func repeatdraw(){
        if TargetImage.frame.midX < PointerObject.frame.maxX && TargetImage.frame.midX > PointerObject.frame.minX && TargetImage.frame.midY < PointerObject.frame.maxY && TargetImage.frame.midY > PointerObject.frame.minY {
            stopTimer = true
            checkmark = true
            showRightorWrong()
            //put a 1 sec delay
            //display a check mark or a red cross for 1 sec after each question, then load the next question
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.doneQuestion(correct: true)
            })
            
        }
        if (stopTimer){ //correct answer
            stopTimer = false
            return
        }
        self.cireView.value += 2
        if self.cireView.value == 100 {
            checkmark = false
            self.cireView.value = 0
            showRightorWrong()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.doneQuestion(correct: false)
            })
            return
        }
        
        self.perform(#selector(EmotionRecognitionViewController.repeatdraw), with: self, afterDelay: 0.2)
    }
    
    /*func runTimer() {
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
     }*/
    // Define a view
    var popup:UIView!
    func showRightorWrong() {
        // customise your view
        popup = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
        if(checkmark){
            popup.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "checkmark"))
        }
        else{
            popup.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "crossmark"))
        }
        popup.center = self.view.center
        popup.contentMode = .scaleAspectFit
        // show on screen
        self.view.addSubview(popup)
        
        // set the timer so the view will display for 1 seconds
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    @objc func dismissAlert(){
        if popup != nil { // Dismiss the view from here
            popup.removeFromSuperview()
        }
    }
    func quizFinish() {
        /*if timer != nil {
         timer?.invalidate()
         timer = nil
         }*/
        
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

