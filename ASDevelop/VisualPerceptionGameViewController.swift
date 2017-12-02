//
//  VisualPerceptionviewController.swift
//  ASDevelop
//
//  Created by aboswell on 11/13/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import AVFoundation

class VisualPerceptionViewController: UIViewController, AVAudioPlayerDelegate {
    
    var studentIndex = 0
    var moduleIndex = 0
    var xpGained = 0
    var quizNumber = 0
    var ModuleStartViewController:ModuleStartViewController?
    
    //21 images
    let objectImages = [UIImage(named: "apple.png")!,
                        UIImage(named: "banana.png")!,
                        UIImage(named: "campfire.png")!,
                        UIImage(named: "mapleleaf.png")!,
                        UIImage(named: "cow.png")!,
                        UIImage(named: "crab.png")!,
                        UIImage(named: "drum.png")!,
                        UIImage(named: "flipflops.png")!,
                        UIImage(named: "guitar.png")!,
                        UIImage(named: "icecream.png")!,
                        UIImage(named: "owl.png")!,
                        UIImage(named: "pig.png")!,
                        UIImage(named: "pineapple.png")!,
                        UIImage(named: "popsicle.png")!,
                        UIImage(named: "pumpkin.png")!,
                        UIImage(named: "rabbit.png")!,
                        UIImage(named: "shovel.png")!,
                        UIImage(named: "strawberry.png")!,
                        UIImage(named: "sun.png")!,
                        UIImage(named: "umbrella.png")!,
                        UIImage(named: "watermelon.png")!] //21
    
    let objectImages_level2 = [UIImage(named: "apple_level2.png")!,
                               UIImage(named: "banana_level2.png")!,
                               UIImage(named: "campfire_level2.png")!,
                               UIImage(named: "mapleleaf_level2.png")!,
                               UIImage(named: "cow_level2.png")!,
                               UIImage(named: "crab_level2.png")!,
                               UIImage(named: "drum_level2.png")!,
                               UIImage(named: "flipflops_level2.png")!,
                               UIImage(named: "guitar_level2.png")!,
                               UIImage(named: "icecream_level2.png")!,
                               UIImage(named: "owl_level2.png")!,
                               UIImage(named: "pig_level2.png")!,
                               UIImage(named: "pineapple_level2.png")!,
                               UIImage(named: "popsicle_level2.png")!,
                               UIImage(named: "pumpkin_level2.png")!,
                               UIImage(named: "rabbit_level2.png")!,
                               UIImage(named: "shovel_level2.png")!,
                               UIImage(named: "strawberry_level2.png")!,
                               UIImage(named: "sun_level2.png")!,
                               UIImage(named: "umbrella_level2.png")!,
                               UIImage(named: "watermelon_level2.png")!]    //
    
    
    
    
    let totalQuestions = 10
    var currentQuestion = 0
    var correctAnswer = 0
    var answersCorrect = 0
    
    var correctSound:AVAudioPlayer?
    var incorrectSound:AVAudioPlayer?
    
    
    //couldnt figure out how to make an array with size 9 so i just used apple.png as placeholders
    var PhotoArray_3x3:[UIImage] = [UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,
                                    UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,
                                    UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,UIImage(named: "apple.png")!]
    var PhotoArray_3x3_level2:[UIImage] = [UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,
                                           UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,
                                           UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,UIImage(named: "apple.png")!]
    var questions_Images:[UIImage] = [UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,
                                      UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,
                                      UIImage(named: "apple.png")!,UIImage(named: "apple.png")!,UIImage(named: "apple.png")!]
    var answers_boolean:[Bool] = [false,false,false]
    var responses_boolean:[Bool] = [false,false,false]
    
    @IBOutlet weak var ModuleProgressField: UITextField!
    //fraction displayed in the lower left corner
    
    //three choices that will have images
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var middleImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    //three checkboxes next to the images
    @IBOutlet weak var topCheckbox: UIButton!
    @IBOutlet weak var middleCheckbox: UIButton!
    @IBOutlet weak var bottomCheckbox: UIButton!
    
    @IBOutlet weak var image_11: UIImageView!
    @IBOutlet weak var image_12: UIImageView!
    @IBOutlet weak var image_13: UIImageView!
    @IBOutlet weak var image_21: UIImageView!
    @IBOutlet weak var image_22: UIImageView!
    @IBOutlet weak var image_23: UIImageView!
    @IBOutlet weak var image_31: UIImageView!
    @IBOutlet weak var image_32: UIImageView!
    @IBOutlet weak var image_33: UIImageView!
    //2d array of 9 images
    
    //button to submit answers
    @IBOutlet weak var buttonSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        ModuleProgressField.isUserInteractionEnabled = false
        buttonSubmit.layer.cornerRadius = 5
        
        do {
            correctSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "positive", ofType: "wav")!))
            correctSound?.prepareToPlay()
            
            incorrectSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "negative", ofType: "wav")!))
            incorrectSound?.prepareToPlay()
        } catch {
            print(error)
        }
        
        nextQuestion()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuestion(){
        
        //populates photoArray with random images
        generatePhotoArray(photoArray: &PhotoArray_3x3, photos: objectImages,currentQ: currentQuestion)
        
        //populates answers_Images with 3 images as the questions
        generateQuestions(photoArray: PhotoArray_3x3, questions: &questions_Images)
        
        //populates answers_boolean with true and false values
        getAnswers(photoArray: PhotoArray_3x3, answers: &answers_boolean, questions: questions_Images)
        
        if(instructor.students[studentIndex].modules[moduleIndex].level > 1){
            //populates photoArray with random images from level 2
            generatePhotoArray(photoArray: &PhotoArray_3x3, photos: objectImages_level2, currentQ: currentQuestion)
            
        }
        
        //reset answers and boxes
        resetCheckBox(thisResponse: &responses_boolean[0], thisButton: topCheckbox)
        resetCheckBox(thisResponse: &responses_boolean[1], thisButton: middleCheckbox)
        resetCheckBox(thisResponse: &responses_boolean[2], thisButton: bottomCheckbox)
        
        //show questions
        topImage.image = questions_Images[0]
        middleImage.image = questions_Images[1]
        bottomImage.image = questions_Images[2]
        
        //updates the image view, turn into function later?
        image_11.image = PhotoArray_3x3[0]
        image_12.image = PhotoArray_3x3[1]
        image_13.image = PhotoArray_3x3[2]
        image_21.image = PhotoArray_3x3[3]
        image_22.image = PhotoArray_3x3[4]
        image_23.image = PhotoArray_3x3[5]
        image_31.image = PhotoArray_3x3[6]
        image_32.image = PhotoArray_3x3[7]
        image_33.image = PhotoArray_3x3[8]
        
        //for now the string can be changed in the app which isnt good
        ModuleProgressField.text = String(currentQuestion + 1)
        
        //increment question counter
        currentQuestion = currentQuestion + 1
    }
    
    //updates class variables and return to modules
    func quizFinished(){
        instructor.students[studentIndex].modules[moduleIndex].addXP(xp: xpGained)
        presentModuleFinishScreen(xpGained: answersCorrect)
    }
    
    //these functions change the color of the checkboxes
    @IBAction func topCheckbox_Pressed(_ sender: Any) {
        updateCheckBox(thisResponse: &responses_boolean[0], thisButton: topCheckbox)
    }
    @IBAction func middleCheckbox_Pressed(_ sender: Any) {
        updateCheckBox(thisResponse: &responses_boolean[1], thisButton: middleCheckbox)
    }
    @IBAction func bottomCheckbox_Pressed(_ sender: Any) {
        updateCheckBox(thisResponse: &responses_boolean[2], thisButton: bottomCheckbox)
    }
    
    //reads input from the button and changes the box color
    func updateCheckBox(thisResponse: inout Bool, thisButton:  UIButton){
        //switch response
        if(thisResponse == false){
            thisResponse = true;
        }
        else{
            thisResponse = false
        }
        //update box color
        if(thisResponse == true){
            thisButton.backgroundColor = UIColor.green
        }
        else{
            thisButton.backgroundColor = UIColor.white
        }
    }
    
    func resetCheckBox(thisResponse: inout Bool, thisButton:  UIButton){
        thisResponse = false;
        thisButton.backgroundColor = UIColor.white
    }
    
    //generates an array of 9 images randomly
    func generatePhotoArray(photoArray: inout [UIImage], photos: [UIImage], currentQ: Int){
        
        //let seed = UInt32(objectImages.count)
        
        //let randNum = Int(arc4random_uniform(seed))
        
        //made it nonrandom just so the level 2 images could be implemented easily
        //to make this part random, save the randNum for both function calls since this wil get called twice
        
        for i in 0...8{
            //photoArray[i] = photos[(randNum + 2 + i) % photos.count]
            photoArray[i] = photos[(2*i + currentQ) % photos.count]
        }
        
    }
    
    //generates answers by searching through the photoArray using the questions
    func getAnswers(photoArray: [UIImage], answers: inout [Bool], questions: [UIImage]){
        
        answers = [false, false, false]
        
        for i in 0...2{
            
            for j in 0...8{
                
                if(questions[i] == photoArray[j]){
                    answers[i] = true
                    break
                }
            }
        }
    }
    
    //wish i could make photoArray static
    //generates the questions randomly
    func generateQuestions(photoArray: [UIImage], questions: inout [UIImage]){
        
        let seed = UInt32(objectImages.count)
        
        
        let randNum = Int(arc4random_uniform(seed)) // 0 to 21
        
        questions[0] = objectImages[randNum ]
        questions[1] = objectImages[(randNum + 2)%objectImages.count]
        questions[2] = objectImages[(randNum  + 4)%objectImages.count]
    }
    
    
    @IBAction func submit_Pressed(_ sender: Any) {
        
        //check the answers, if answers are incorrect then play the error sound
        //else prompt next question
        //if this is the last question end the quiz
        
        //if the answers are correct
        if(responses_boolean[0] == answers_boolean[0])&&(responses_boolean[1] == answers_boolean[1])&&(responses_boolean[2] == answers_boolean[2]){
            correctSound?.volume = instructor.volume
            correctSound?.play()
            xpGained = xpGained + 1
            answersCorrect = answersCorrect + 1
        }
        else{
            incorrectSound?.volume = instructor.volume
            incorrectSound?.play()
        }
        
        if(currentQuestion <= totalQuestions - 1 ){
            nextQuestion()
        }
        else{
            quizFinished()
        }
    }
    
    //present login screen after successfully logged in
    func presentModuleFinishScreen(xpGained: Int) {
        
        //Create the new view
        let ModuleFinishViewController:ModuleFinishViewController = storyboard!.instantiateViewController(withIdentifier: "NewModuleFinishViewController") as! ModuleFinishViewController
        
        //Assign the instructor class to the new logged in view
        ModuleFinishViewController.moduleIndex = moduleIndex
        ModuleFinishViewController.studentIndex = studentIndex
        ModuleFinishViewController.xpGained = xpGained
        ModuleFinishViewController.VisualPerceptionViewController = self
        
        //Change the view to the new view
        self.present(ModuleFinishViewController, animated: true, completion: nil)
    }
}

