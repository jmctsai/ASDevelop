//
//  EmotionRecognitionGameViewController.swift
//  ASDevelop
//
//  Created by lmulder on 11/6/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth
import AVFoundation

class EmotionRecognitionViewController: UIViewController, AVAudioPlayerDelegate {

    var quizNumber = 0
    var moduleIndex = 0
    var studentIndex = 0
    var xpGained = 0
    var ModuleStartViewController:ModuleStartViewController?
    
    let emotionImageArray:[UIImage] = [
        UIImage(named: "happy.png")!,
        UIImage(named: "angry.jpeg")!,
        UIImage(named: "afraid.jpg")!,
        UIImage(named: "surprise.png")!,
        UIImage(named: "interested.png")!,
        UIImage(named: "worried.png")!,
        UIImage(named: "sad.png")!,
        UIImage(named: "excited.png")!,
        UIImage(named: "bored.png")!,
        UIImage(named: "joking.png")!]
    
    let answers = [["Happy", "Angry", "Surprised"], ["Angry", "Sad", "Afraid"], ["Afraid", "Angry", "Disgusted"],["Surprised", "Happy", "Afraid"], ["Interested", "Happy", "Afraid"], ["Worried", "Happy", "Afraid"], ["Sad", "Happy", "Afraid"], ["Excited", "Happy", "Afraid"], ["Bored", "Happy", "Afraid"],
                   ["Joking", "Happy", "Afraid"]]
    
    let totalQuestions = 10
    var currentQuestion = 0
    var correctAnswer = 0
    var answersCorrect = 0
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    
    @IBOutlet weak var ModuleProgressField: UITextField!
    @IBOutlet weak var EmotionImage: UIImageView!
    
    var correctSound:AVAudioPlayer?
    var incorrectSound:AVAudioPlayer?
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender.tag == correctAnswer {
            answersCorrect = answersCorrect + 1
            correctSound?.play()
        } else {
            incorrectSound?.play()
        }
    
        if currentQuestion < totalQuestions - 1 {
            nextQuestion()
        } else {
            quizFinished()
        }
    }
    
    func nextQuestion() {
        let firstIndex = Int(arc4random_uniform(3))

        EmotionImage.image = emotionImageArray[currentQuestion]
        ModuleProgressField.text = String(currentQuestion + 1) + "/" + String(totalQuestions)
        
        let answer1 = answers[currentQuestion][firstIndex]
        let answer2 = answers[currentQuestion][(firstIndex + 1) % 3]
        let answer3 = answers[currentQuestion][(firstIndex + 2) % 3]
        
        // Find the corrext answer index
        for i in 0...2 {
            if (firstIndex + i) % 3 == 0 {
                correctAnswer = i + 1
            }
        }
        
        Button1.setTitle(answer1, for: .normal)
        Button2.setTitle(answer2, for: .normal)
        Button3.setTitle(answer3, for: .normal)
        
        currentQuestion = currentQuestion + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            correctSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "positive", ofType: "wav")!))
            correctSound?.prepareToPlay()
            
            incorrectSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "negative", ofType: "wav")!))
            incorrectSound?.prepareToPlay()
        } catch {
            print(error)
        }
        
        nextQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func quizFinished()
    {
        instructor.students[studentIndex].modules[moduleIndex].addXP(xp: answersCorrect)
        presentModuleFinishScreen(xpGained: answersCorrect)
    }
    
    //present login screen after successfully logged in
    func presentModuleFinishScreen(xpGained: Int) {
        
        //Create the new view
        let ModuleFinishViewController:ModuleFinishViewController = storyboard!.instantiateViewController(withIdentifier: "NewModuleFinishViewController") as! ModuleFinishViewController
        
        //Assign the instructor class to the new logged in view
        ModuleFinishViewController.moduleIndex = moduleIndex
        ModuleFinishViewController.studentIndex = studentIndex
        ModuleFinishViewController.xpGained = xpGained
        ModuleFinishViewController.EmotionRecognitionViewController = self
        
        //Change the view to the new view
        self.present(ModuleFinishViewController, animated: true, completion: nil)
    }
    
}
