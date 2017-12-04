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
    
    
    //answer buttons
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    
    @IBOutlet weak var ModuleProgressField: UITextField!
    @IBOutlet weak var EmotionImage: UIImageView!
    
    var correctSound:AVAudioPlayer?
    var incorrectSound:AVAudioPlayer?
    
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
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        stopTimer = true
        if sender.tag == correctAnswer {
            
            //+2 xp if answered within the first 10 seconds
            if (round < 1){
                XP += 2
            }
            else{
                XP += 1
            }
            checkmark = true
            correctSound?.volume = instructor.volume
            correctSound?.play()
        }
        else {
            checkmark = false
            incorrectSound?.volume = instructor.volume
            incorrectSound?.play()
        }
        print("current xp: ", XP)
        showRightorWrong()
        //put a 1 sec delay
        //display a check mark or a red cross for 1 sec after each question, then load the next question
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.loadNext()
        })
        
    }
    func loadNext(){
        if ((currentQuestion < totalQuestions)) {
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
        if (instructor.students[studentIndex].modules[moduleIndex].level == 1){
            EmotionImage.image = firstLevel[currentQuestion].questionImage
            answer1 = firstLevel[currentQuestion].answerArr[firstIndex]
            answer2 = firstLevel[currentQuestion].answerArr[(firstIndex + 1) % 3]
            answer3 = firstLevel[currentQuestion].answerArr[(firstIndex + 2) % 3]
        }
        else if (instructor.students[studentIndex].modules[moduleIndex].level == 2){
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
        creatCire() //create a count down timer for each question
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if (stopTimer){ //button hitted
            stopTimer = false
            return
        }
        self.cireView.value += 2
        if self.cireView.value == 100 {
            round += 1
            if (round == 1){
                self.cireView.value = 0
            }
            else if (round == 2){
                checkmark = false
                showRightorWrong()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.loadNext()
                })
                return
            }
        }
        self.perform(#selector(EmotionRecognitionViewController.repeatdraw), with: self, afterDelay: 0.2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
     
    
    func quizFinished()
    {
        presentModuleFinishScreen(xpGained: XP)
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

