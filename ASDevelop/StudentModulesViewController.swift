//
//  StudentModulesViewController.swift
//  ASDevelop
//
//  Created by lmulder on 11/5/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth

class StudentModulesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var studentModuleText: UILabel!
    
    var InstructorClassroomViewController:InstructorClassroomViewController?
    var studentIndex:Int?
    
    var photoArray = [textToImage(drawText: "Add New Module", inImage: UIImage(named:"AddButton.png")!, atPoint: CGPoint(x: 15,y: 235))]
    
    @IBOutlet weak var StudentModulesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if instructor.students.count > studentIndex! {
            studentModuleText.text = (instructor.students[studentIndex!].firstName) + "'s Modules"
        }
        self.StudentModulesCollectionView.delegate = self
        self.StudentModulesCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePhotoArray()
        self.reloadInputViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 383, height: 262))
        imageview.image = photoArray[indexPath.row]
        cell.contentView.addSubview(imageview)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == photoArray.count - 1 {
            presentNewModulesViewController()
        } else {
            presentModuleStartScreen(moduleIndex: indexPath.row)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //Send Student Data Back
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToStudentModules(segue: UIStoryboardSegue) {
        
    }
    
    func updatePhotoArray() {
        photoArray.removeAll()
        
        for nextModule in instructor.students[studentIndex!].modules {
            photoArray.append(createModuleImage(module: nextModule))
        }

        photoArray.append(textToImage(drawText: "New Module", inImage: UIImage(named:"AddButton.png")!, atPoint: CGPoint(x: 15,y: 235)))
        
        self.StudentModulesCollectionView.reloadData()
    }
    
    func createModuleImage(module: Module) -> UIImage {
        let name = module.name
        var photo = module.modulePhoto
        let xp = module.xp
        let level = "Level " + String(module.level) as NSString
        
        photo = textToImage(drawText: name as NSString, inImage: photo!, atPoint: CGPoint(x: 15,y: 235))
        photo = textToImage(drawText: level, inImage: photo!, atPoint: CGPoint(x: 220,y: 235))
        photo = overlayProgressBar(image: photo!, progressBar: createProgressBar(hexBGColor: "1C90E7", hexFGColor: "1747BB", width: 87, height: 20, xp: xp))
        
        return photo!
    }
    
    func onNewModule(newModule: Module) {
        instructor.students[studentIndex!].addModule(module: newModule)
        let displayImage = newModule.modulePhoto
        let displayText = (newModule.name) as NSString
        photoArray.insert(textToImage(drawText: displayText, inImage: displayImage!, atPoint: CGPoint(x: 15,y: 235)), at: 0)
        
        self.StudentModulesCollectionView.reloadData()
    }
    
    //present login screen after successfully logged in
    func presentModuleStartScreen(moduleIndex: Int) {
        
        //Create the new view
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let ModuleStartViewController:ModuleStartViewController = storyboard.instantiateViewController(withIdentifier: "NewModuleStartViewController") as! ModuleStartViewController
        
        //Assign the instructor class to the new logged in view
        ModuleStartViewController.studentModulesViewController = self
        ModuleStartViewController.moduleIndex = moduleIndex
        ModuleStartViewController.studentIndex = studentIndex!
        
        //Change the view to the new view
        self.present(ModuleStartViewController, animated: true, completion: nil)
    }
    
    //present login screen after successfully logged in
    func presentNewModulesViewController() {
        
        //Create the new view
        let NewModuleViewController:NewModuleViewController = storyboard!.instantiateViewController(withIdentifier: "NewModuleViewController") as! NewModuleViewController
        
        //Assign the current view to the parent view
        NewModuleViewController.studentModulesViewController = self
        
        //Assign the student index to the StudentModulesView
        NewModuleViewController.studentIndex = studentIndex!
        
        //Change the view to the new view
        self.present(NewModuleViewController, animated: true, completion: nil)
    }
    
}

func overlayProgressBar(image: UIImage, progressBar: UIImage) -> UIImage {
    
    let newSize = CGSize(width:383, height:262) // set this to what you need
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    
    image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: image.size))
    progressBar.draw(in: CGRect(origin: CGPoint(x: 280,y :235), size: progressBar.size))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}


