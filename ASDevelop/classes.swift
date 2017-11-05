//
//  Instructor.swift
//  ASDevelop
//
//  Created by lmulder on 11/4/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class Module {
    var name: String
    var level: Int
    var xp: Int
    var modulePhoto: UIImage?
    var startPhoto: UIImage?
    
    init(name: String, level: Int, modulePhoto: UIImage?, startPhoto: UIImage?, xp: Int)
    {
        self.name = name
        self.level = level
        self.modulePhoto = modulePhoto
        self.startPhoto = startPhoto
        self.xp = xp
    }
    
    init(num: Int)
    {
        self.name = GlobalModules.names[num]
        self.modulePhoto = GlobalModules.modulePhotos[num]
        self.startPhoto = GlobalModules.startPhotos[num]
        self.level = 1
        self.xp = 0
    }
    
    private func levelUp()
    {
        self.level = self.level + 1
    }
    
    func addXP(xp: Int)
    {
        self.xp = self.xp + xp
        if self.xp >= 100
        {
            self.levelUp()
            self.xp = self.xp - 100
        }
    }
}

struct GlobalModules {
    static var names:[String] = ["Emotion Identification", "Visual Perception", "Motion Control"]
    static var modulePhotos:[UIImage?] = [UIImage(named: "EmotionModule"), UIImage(named: "VisualModule"), UIImage(named: "MotionModule")]
    static var startPhotos:[UIImage?] = [UIImage(named: "EmotionStart"), UIImage(named: "VisualStart"), UIImage(named: "MotionStart")]
}

class Student {
    var modules: [Module]
    var firstName: String
    var age: Int
    var photo: UIImage?
    
    init(modules: [Module], firstName: String, age: Int, photo: UIImage?)
    {
        self.modules = modules
        self.firstName = firstName
        self.age = age
        self.photo = photo
    }
    
    func changePhoto(photo: UIImage?)
    {
        self.photo = photo
    }
    
    func addModule(module: Module)
    {
        self.modules.append(module)
    }
}

class Instructor {
    var students: [Student]
    var email: String
    
    init(students: [Student], email: String)
    {
        self.students = students
        self.email = email
    }
    
    func changeEmail(email: String)
    {
        self.email = email
    }
    
    func addStudent(student: Student)
    {
        self.students.append(student)
    }
}
