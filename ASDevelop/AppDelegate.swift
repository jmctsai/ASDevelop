//
//  AppDelegate.swift
//  ASDevelop
//
//  Created by Johnny Tsai on 10/27/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        return true
    }



}

