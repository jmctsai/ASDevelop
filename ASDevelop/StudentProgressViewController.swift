//
//  StudentProgressViewController.swift
//  ASDevelop
//
//  Created by lmulder on 2017-11-17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth

class StudentProgressViewController: UIViewController {
    
    @IBOutlet weak var StudentProgressTitleField: UILabel!
    
    var studentIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if instructor.students.count > studentIndex! {
            StudentProgressTitleField.text = (instructor.students[studentIndex!].firstName) + "'s Progress"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //Send Student Data Back
        dismiss(animated: true, completion: nil)
    }
}
