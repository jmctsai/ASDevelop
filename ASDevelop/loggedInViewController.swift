//
//  loggedInViewController.swift
//  ASDevelop
//
//  Created by Johnny Tsai on 2017-11-01.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth

class loggedInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        
            dismiss(animated: true, completion: nil)
            
        } catch {
            print ("There was a problem logging out.. Try again later")
        }
    }
}
