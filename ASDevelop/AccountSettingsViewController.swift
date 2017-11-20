//
//  AccountSettingsViewController.swift
//  ASDevelop
//
//  Created by Amitoj Singh Gill on 2017-11-15.
//  Copyright Â© 2017 CMPT275. All rights reserved.
//

import UIKit
import Firebase

class AccountSettingsViewController: UIViewController {
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        volumeSlider.value = instructor.volume
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // go back to classroom
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeSettingsButtonPressed(_ sender: Any) {
        //Assign the new volume to instructor
        instructor.volume = volumeSlider.value
        // go back to classroom
        dismiss(animated: true, completion: nil)
    }
    
}
