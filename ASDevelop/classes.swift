//
//  Instructor.swift
//  ASDevelop
//
//  Created by lmulder on 11/4/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

var instructor = Instructor()

class Module {
    var name: String
    var level: Int
    var xp: Int
    var modulePhoto: UIImage?
    var startPhoto: UIImage?
    var timedXP: TimedXP
    
    init(name: String, level: Int, modulePhoto: UIImage?, startPhoto: UIImage?, xp: Int)
    {
        self.name = name
        self.level = level
        self.modulePhoto = modulePhoto
        self.startPhoto = startPhoto
        self.xp = xp
        if xp > 0
        {
            self.timedXP = TimedXP(xp: xp)
        }
        else
        {
            self.timedXP = TimedXP()
        }
    }
    
    init(num: Int)
    {
        self.name = GlobalModules.names[num]
        self.modulePhoto = GlobalModules.modulePhotos[num]
        self.startPhoto = GlobalModules.startPhotos[num]
        self.level = 1
        self.xp = 0
        self.timedXP = TimedXP()
    }
    
    private func levelUp()
    {
        self.level = self.level + 1
    }
    
    func addXP(xp: Int)
    {
        self.xp = self.xp + xp
        self.timedXP.addXP(xp: xp)
        if self.xp >= 100
        {
            self.levelUp()
            self.xp = self.xp - 100
        }
    }
}

class TimedXP {
    var list : [Int]
    var date : [Date]
    var count : Int
    
    init()
    {
        self.list = [Int]()
        self.date = [Date]()
        self.count = 0
    }
    
    init(xp: Int)
    {
        self.list = [xp]
        self.date = [Date()]
        self.count = 1
    }
    
    func addXP(xp: Int)
    {
        self.list.append(xp)
        self.date.append(Date())
        self.count = self.count + 1
    }
}

struct GlobalModules {
    static var names:[String] = ["Emotion Identification", "Visual Perception", "Motion Control"]
    static var modulePhotos:[UIImage?] = [UIImage(named: "EmotionModule"), UIImage(named: "VisualModule"), UIImage(named: "MotorModule")]
    static var startPhotos:[UIImage?] = [UIImage(named: "EmotionStart"), UIImage(named: "VisualStart"), UIImage(named: "MotorStart")]
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
    
    init()
    {
        self.students = [Student]()
        self.email = ""
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

class LandscapeUIImagePickerController: UIImagePickerController {
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .all
    }
}

func createProgressBar(hexBGColor: String, hexFGColor: String,width: Int, height: Int, xp: Int) -> UIImage {
    
    let newSize = CGSize(width: width, height: height) // set this to what you need
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    
    UIColor(hex: hexFGColor).set()
    var rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width:width, height:height))
    UIRectFill(rect)
    UIColor(hex: hexBGColor).set()
    rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: Int(Double(width)*(Double(xp)/100.0)), height:height))
    UIRectFill(rect)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
    let textColor = UIColor.white
    let textFont = UIFont(name: "Helvetica Bold", size: 16)!
    
    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
    
    var textFontAttributes = [NSAttributedStringKey: Any]()
    
    textFontAttributes = [
        .font: textFont,
        .foregroundColor: textColor,
    ]
    image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
    
    let rect = CGRect(origin: point, size: image.size)
    text.draw(in: rect, withAttributes: textFontAttributes)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

//Fisher–Yates shuffle
extension Array {
    mutating func shuffle() {
        for i in stride(from: count - 1, to: 1, by: -1){
            let j = Int(arc4random_uniform(UInt32(i)))
            swapAt(i, j)
        }
}
}
