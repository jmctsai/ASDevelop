//
//  VisualPerceptionviewController.swift
//  ASDevelop
//
//  Created by aboswell on 11/13/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class VisualPerceptionViewController: UIViewController {

    var studentIndex = 0
    var moduleIndex = 0
    var xpGained = 0
    var quizNumber = 0
    var ModuleStartViewController:ModuleStartViewController?
    
    let totalQuestions = 10
    var currentQuestion = 0
    var correctAnswer = 0
    var answersCorrect = 0
    
    let objectImageArray:[UIImage] = [
        UIImage(named: "apple.png")!,
        UIImage(named: "banana.png")!,
        UIImage(named: "campfire.png")!,
        UIImage(named: "canadaflag.png")!,
        UIImage(named: "cow.png")!,
        UIImage(named: "crab.png")!,
        UIImage(named: "drum.png")!,
        UIImage(named: "emoji.png")!,
        UIImage(named: "flipflops.png")!,
        UIImage(named: "guitar.png")!,
        UIImage(named: "shovel.png")!,
        UIImage(named: "owl.png")!,
        UIImage(named: "pig.png")!,
        UIImage(named: "banana.png")!,
        UIImage(named: "popsicle.png")!,
        UIImage(named: "pumpkin.png")!,
        UIImage(named: "rabbit.png")!,
        UIImage(named: "shovel.png")!,
        UIImage(named: "strawberry.png")!,
        UIImage(named: "sun.png")!,
        UIImage(named: "umbrella.png")!,
        UIImage(named: "cow.png")!]
    
    let answers = [["umbrella.png", "cow.png", "shovel.png", "flipflops.png", "drum.png", "popsicle.png", "rabbit.png", "strawberry.png", "campfire.png"],
                   ["flipflops.png", "banana.png", "shovel.png", "emoji.png", "popsicle.png", "guitar.png", "rabbit.png", "strawberry.png", "apple.png"],
                   ["apple.png", "cow.png", "umbrella.png", "shovel.png", "crab.png", "banana.png", "pig.png", "owl.png", "drum.png"],
                   ["owl.png", "umbrella.png", "strawberry.png", "canadaflag.png", "shovel.png", "apple.png", "emoji.png", "banana.png", "guitar.png"]]
    //array of answers but there are only 4 questions
    
    
    @IBOutlet weak var ModuleProgressField: UITextField!
    //fraction displayed in the lower left corner
    
    //three choices that will have images
    @IBOutlet weak var topChoice: UIButton!
    @IBOutlet weak var middleChoice: UIButton!
    @IBOutlet weak var bottomChoice: UIButton!
    
    //three checkboxes next to the images
    @IBOutlet weak var topCheckbox: UIButton!
    @IBOutlet weak var middleCheckbox: UIButton!
    @IBOutlet weak var bottomCheckbox: UIButton!
    
    @IBOutlet weak var imageArray: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextQuestion()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuestion(){
        
    }
    


}
