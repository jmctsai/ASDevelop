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
    static var names:[String] = ["Emotion Identification", "Visual Perception", "Motor Control"]
    static var modulePhotos:[UIImage?] = [UIImage(named: "EmotionModule"), UIImage(named: "VisualModule"), UIImage(named: "MotorModule")]
    static var startPhotos:[UIImage?] = [UIImage(named: "EmotionStart"), UIImage(named: "VisualStart"), UIImage(named: "MotorStart")]
}

class Student {
    var modules: [Module]
    var firstName: String
    var age: Int
    var photo: UIImage?
    var studentID: String
    
    init(modules: [Module], firstName: String, age: Int, photo: UIImage?, studentID: String)
    {
        self.modules = modules
        self.firstName = firstName
        self.age = age
        self.photo = photo
        self.studentID = studentID
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
    var volume: Float
    
    init(students: [Student], email: String)
    {
        self.students = students
        self.email = email
        self.volume = 100.0
    }
    
    init()
    {
        self.students = [Student]()
        self.email = ""
        self.volume = 100.0
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

// Draws a string onto the users profile image
// Output will always be of size 383x262
func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
    let textColor = UIColor.white
    let textFont = UIFont(name: "Helvetica Bold", size: 16)!
    
    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 383, height: 262), false, scale)
    
    var textFontAttributes = [NSAttributedStringKey: Any]()
    
    textFontAttributes = [
        .font: textFont,
        .foregroundColor: textColor,
    ]
    image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 383, height: 262)))
    
    let rect = CGRect(origin: point, size: CGSize(width: 383, height: 262))
    text.draw(in: rect, withAttributes: textFontAttributes)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

//Allow conversion from date onject to the number of the day of the week
// 1 = Sunday, 2 = Monday, ...
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
    }
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

// Extension to allow ImageViews to be drag and dropable
class ObjectView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var initialLocation: CGPoint?
    
    // If user has touched the View save initial location
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        initialLocation = CGPoint(x: (touch?.location(in: self.superview))!.x - self.center.x, y: (touch?.location(in: self.superview))!.y - self.center.y)
    }
    
    // If the user moves the View change the location
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        self.center = CGPoint(x: ((touch?.location(in: self.superview))?.x)! - initialLocation!.x, y: ((touch?.location(in: self.superview))?.y)! - (initialLocation?.y)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
