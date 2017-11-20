//
//  AccountSettingsViewController.swift
//  ASDevelop
//
//  Created by Amitoj Singh Gill on 2017-11-15.
//  Copyright Â© 2017 CMPT275. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

var correctSoundPlay:AVAudioPlayer?
var incorrectSoundPlay:AVAudioPlayer?

class AccountSettingsViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var volumeLabel: UILabel!
    
    // update volume according to the slider
    @IBAction func changeVolume(_ sender: Any) {
        UserDefaults.standard.set(volumeSlider.value, forKey: "volumeState")
        let currVolume = roundf(volumeSlider.value) * 10
        volumeLabel.text = "\(currVolume)%"
        correctSoundPlay?.volume = volumeSlider.value
        incorrectSoundPlay?.volume = volumeSlider.value
    }
    
    // update the email on firebase system
    @IBAction func emailEntered(_ sender: Any) {
        UserDefaults.standard.setValue(emailSetup.text, forKey: "textState")
        var emailPorG = emailSetup.text
        let uid = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("Instructors").child(uid!)
        let value = ["PorGemail": emailPorG]
        userRef.updateChildValues(value) { (database_update_error, ref) in
            if database_update_error != nil {
                print(database_update_error!)
                return
            }
            print("Saved Instructors in database")
        }
    }
    
    @IBOutlet weak var resetButtonTapped: UIButton!
    // reset all button tapped, reset all fields
    @IBAction func resetButton(_ sender: Any) {
        // if volume slider is not at 100%
        if volumeSlider.value != Float(10) {
            volumeSlider.value = Float(10)
            volumeLabel.text = "\(roundf(volumeSlider.value) * 10)%"
            correctSoundPlay?.volume = volumeSlider.value
            incorrectSoundPlay?.volume = volumeSlider.value
        }
        // if mute button is on
        if muteSwitchTapped.isOn {
            correctSoundPlay?.volume = Float(10)
            incorrectSoundPlay?.volume = Float(10)
            muteSwitchTapped.setOn(false, animated: false) //move switch to off
        }
        // if email field is not empty
        if emailSetup.text != "" {
            emailSetup.text = ""
        }
    }
    
    @IBOutlet weak var emailSetup: UITextField!
    
    @IBOutlet weak var muteSwitchTapped: UISwitch!
    
    // mute button tapped, set volume to 0
    @IBAction func muteSwitch(_ sender: Any) {
        UserDefaults.standard.set(muteSwitchTapped.isOn, forKey: "switchState")
        //AVaudioplayer instance.volume = 0
        if muteSwitchTapped.isOn {
            correctSoundPlay?.volume = 0
            incorrectSoundPlay?.volume = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "switchState") {
            muteSwitchTapped.isOn = true
        }
        else {
            muteSwitchTapped.isOn = false
        }
        
        if let emailFieldValue = UserDefaults.standard.string(forKey: "textState") {
            emailSetup.text = emailFieldValue
        }
        
        let valueSlider = UserDefaults.standard.float(forKey: "volumeState")
        if  valueSlider >= 0 {
            volumeSlider.value = valueSlider
        }
        /*
        if let resetButtonTapped.isSelected = UserDefaults.standard.bool(forKey: "resetState") {
            
        }
        do {
            correctSoundPlay = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "positive", ofType: "wav")!))
            correctSoundPlay?.prepareToPlay()
            
            incorrectSoundPlay = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "negative", ofType: "wav")!))
            incorrectSoundPlay?.prepareToPlay()
        } catch {
            print(error)
        }
        */
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // go back to Students Module
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
