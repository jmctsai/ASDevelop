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
    var level = 1 //game level is 1 by default
    var ModuleStartViewController:ModuleStartViewController?
    
    //A struct stores a Question and an Answer array
    struct QA{
        var questionImage: UIImage
        var answerArr: [String]
        
        init(questionImage: UIImage, answer: [String]) {
            self.questionImage = questionImage
            self.answerArr = answer
        }
    }
    
    //QA(Question and answer) array for three levels
    var firstLevel: [QA] = []
    var secondLevel: [QA] = []
    var thirdLevel: [QA] = []
    
    
    let answers = [["Happy", "Angry", "Surprised"], ["Angry", "Sad", "Afraid"], ["Afraid", "Angry", "Disgusted"],["Surprised", "Happy", "Afraid"], ["Interested", "Happy", "Afraid"], ["Worried", "Happy", "Afraid"], ["Sad", "Happy", "Afraid"], ["Excited", "Happy", "Afraid"], ["Bored", "Happy", "Afraid"],
                   ["Joking", "Happy", "Afraid"]]
    
    
    let totalQuestions = 10
    var currentQuestion = 0
    var correctAnswer = 0
    var answersCorrect = 0
    
    //answer buttons
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    
    @IBOutlet weak var ModuleProgressField: UITextField!
    @IBOutlet weak var EmotionImage: UIImageView!
    
    var correctSound:AVAudioPlayer?
    var incorrectSound:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ModuleProgressField.isUserInteractionEnabled = false
        
        Button1.layer.cornerRadius = 10
        Button2.layer.cornerRadius = 10
        Button3.layer.cornerRadius = 10
        
        initQA()
        //prepare sounds
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
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender.tag == correctAnswer {
            answersCorrect = answersCorrect + 1
            correctSound?.volume = instructor.volume
            correctSound?.play()
        } else {
            incorrectSound?.volume = instructor.volume
            incorrectSound?.play()
        }
        
        if currentQuestion < totalQuestions {
            nextQuestion()
        } else {
            quizFinished()
        }
    }
    
    //Display the next question on screen
    func nextQuestion() {
        let firstIndex = Int(arc4random_uniform(3)) //choose a random number from 1 to 3 and set it as the correct answer
        
        var answer1 = ""
        var answer2 = ""
        var answer3 = ""
        
        //load question image and answers based on different levels
        if (level == 1){
            EmotionImage.image = firstLevel[currentQuestion].questionImage
            answer1 = firstLevel[currentQuestion].answerArr[firstIndex]
            answer2 = firstLevel[currentQuestion].answerArr[(firstIndex + 1) % 3]
            answer3 = firstLevel[currentQuestion].answerArr[(firstIndex + 2) % 3]
        }
        else if (level == 2){
            EmotionImage.image = secondLevel[currentQuestion].questionImage
            answer1 = secondLevel[currentQuestion].answerArr[firstIndex]
            answer2 = secondLevel[currentQuestion].answerArr[(firstIndex + 1) % 3]
            answer3 = secondLevel[currentQuestion].answerArr[(firstIndex + 2) % 3]
        }
        else{
            EmotionImage.image = thirdLevel[currentQuestion].questionImage
            answer1 = thirdLevel[currentQuestion].answerArr[firstIndex]
            answer2 = thirdLevel[currentQuestion].answerArr[(firstIndex + 1) % 3]
            answer3 = thirdLevel[currentQuestion].answerArr[(firstIndex + 2) % 3]
        }
        
        ModuleProgressField.text = String(currentQuestion + 1)
        
        
        // Find the correct answer index
        for i in 0...2 {
            if (firstIndex + i) % 3 == 0 {
                correctAnswer = i + 1
            }
        }
        
        //set the button text as the answers
        Button1.setTitle(answer1, for: .normal)
        Button2.setTitle(answer2, for: .normal)
        Button3.setTitle(answer3, for: .normal)
        
        currentQuestion = currentQuestion + 1
    }
    func initQA() {
        firstLevel = [
            QA(questionImage: UIImage(named: "happy.png")!, answer: answers[0]),
            QA(questionImage: UIImage(named: "angry.png")!, answer: answers[1]),
            QA(questionImage: UIImage(named: "afraid.png")!, answer: answers[2]),
            QA(questionImage: UIImage(named: "surprise.png")!, answer: answers[3]),
            QA(questionImage: UIImage(named: "interested.png")!, answer: answers[4]),
            QA(questionImage: UIImage(named: "worried.png")!, answer: answers[5]),
            QA(questionImage: UIImage(named: "sad.png")!, answer: answers[6]),
            QA(questionImage: UIImage(named: "excited.png")!, answer: answers[7]),
            QA(questionImage: UIImage(named: "bored.png")!, answer: answers[8]),
            QA(questionImage: UIImage(named: "joking.png")!, answer: answers[9]),
        ]
        
        secondLevel = [
            QA(questionImage: UIImage(named: "happy2.jpg")!, answer: answers[0]),
            QA(questionImage: UIImage(named: "angry2.jpg")!, answer: answers[1]),
            QA(questionImage: UIImage(named: "afraid2.jpg")!, answer: answers[2]),
            QA(questionImage: UIImage(named: "surprise2.jpg")!, answer: answers[3]),
            QA(questionImage: UIImage(named: "interested2.jpg")!, answer: answers[4]),
            QA(questionImage: UIImage(named: "worried2.jpg")!, answer: answers[5]),
            QA(questionImage: UIImage(named: "sad2.jpg")!, answer: answers[6]),
            QA(questionImage: UIImage(named: "excited2.jpg")!, answer: answers[7]),
            QA(questionImage: UIImage(named: "bored2.jpg")!, answer: answers[8]),
            QA(questionImage: UIImage(named: "joking2.jpg")!, answer: answers[9]),
        ]
        
        thirdLevel = [
            QA(questionImage: UIImage(named: "happy3.jpeg")!, answer: answers[0]),
            QA(questionImage: UIImage(named: "angry3.jpeg")!, answer: answers[1]),
            QA(questionImage: UIImage(named: "afraid3.jpg")!, answer: answers[2]),
            QA(questionImage: UIImage(named: "surprise3.jpg")!, answer: answers[3]),
            QA(questionImage: UIImage(named: "interested3.jpg")!, answer: answers[4]),
            QA(questionImage: UIImage(named: "worried3.jpg")!, answer: answers[5]),
            QA(questionImage: UIImage(named: "sad3.jpg")!, answer: answers[6]),
            QA(questionImage: UIImage(named: "excited3.jpg")!, answer: answers[7]),
            QA(questionImage: UIImage(named: "bored3.jpg")!, answer: answers[8]),
            QA(questionImage: UIImage(named: "joking3.jpg")!, answer: answers[9]),
        ]
        
        //shuffle the question and answer array to have a random order
        firstLevel.shuffle()
        secondLevel.shuffle()
        thirdLevel.shuffle()
        
    }
    
    func quizFinished()
    {
        instructor.students[studentIndex].modules[moduleIndex].addXP(xp: answersCorrect) //!!!*10 for testing only!!!
        presentModuleFinishScreen(xpGained: answersCorrect)
    }
    
    //present module finish screen after quiz is done
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

