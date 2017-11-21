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
    
    // Create collection view photo array and add the new module image
    var photoArray = [textToImage(drawText: "Add New Module", inImage: UIImage(named:"AddButton.png")!, atPoint: CGPoint(x: 15,y: 235))]
    
    @IBOutlet weak var StudentModulesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Write the students name onto the page header
        if instructor.students.count > studentIndex! {
            studentModuleText.text = (instructor.students[studentIndex!].firstName) + "'s Modules"
        }
        
        // Set the collection view to be updated by this view controller
        self.StudentModulesCollectionView.delegate = self
        self.StudentModulesCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Add the student's modules to the collection view
        updatePhotoArray()
        self.reloadInputViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // collection view is the size of the photo array
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get the current cell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 383, height: 262))
        
        // Set the cell image to the correct photo at the current index
        imageview.image = photoArray[indexPath.row]
        
        // Add the image to the cell
        cell.contentView.addSubview(imageview)
        
        // Update the cell in the collection view
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // If the cell pressed is the last element
        if indexPath.row == photoArray.count - 1 {
            // present the new module page
            presentNewModulesViewController()
        } else {
            // present the start of the module selected
            presentModuleStartScreen(moduleIndex: indexPath.row)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // Close the student module page
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func progressIconTapped(_ sender: Any) {
        // Display the progress graph page
        presentStudentProgress()
    }
    
    @IBAction func unwindToStudentModules(segue: UIStoryboardSegue) {
        // Point for the segue in module finish to roll back to if
        // Back to Modules button is pressed
    }
    
    func updatePhotoArray() {
        // Clear the array
        photoArray.removeAll()
        
        // Add all the modules the student has started to the array
        for nextModule in instructor.students[studentIndex!].modules {
            photoArray.append(createModuleImage(module: nextModule))
        }

        // Add the new module button to the end of the array
        photoArray.append(textToImage(drawText: "New Module", inImage: UIImage(named:"AddButton.png")!, atPoint: CGPoint(x: 15,y: 235)))
        
        // Use the photo array to update the collection view
        self.StudentModulesCollectionView.reloadData()
    }
    
    // Create the module image to be placed in the collection view
    // With current level and xp bar
    func createModuleImage(module: Module) -> UIImage {
        let name = module.name
        var photo = module.modulePhoto
        let xp = module.xp
        let level = "Level " + String(module.level) as NSString
        
        // Add the module name and level to the module image
        photo = textToImage(drawText: name as NSString, inImage: photo!, atPoint: CGPoint(x: 15,y: 235))
        photo = textToImage(drawText: level, inImage: photo!, atPoint: CGPoint(x: 220,y: 235))
        
        // Add the progress bar to the module image
        photo = overlayProgressBar(image: photo!, progressBar: createProgressBar(hexBGColor: "1C90E7", hexFGColor: "1747BB", width: 87, height: 20, xp: xp))
        
        return photo!
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
    
    func presentStudentProgress() {
        
        //Create the new view
        let NewStudentProgressViewController:StudentProgressViewController = storyboard!.instantiateViewController(withIdentifier: "NewStudentProgressViewController") as! StudentProgressViewController
        
        NewStudentProgressViewController.studentIndex = studentIndex!
        
        //Change the view to the new view
        self.present(NewStudentProgressViewController, animated: true, completion: nil)
    }
    
}

// Add a progress bar to the module image
func overlayProgressBar(image: UIImage, progressBar: UIImage) -> UIImage {
    
    let newSize = CGSize(width:383, height:262) // set this to what you need
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    
    image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: image.size))
    progressBar.draw(in: CGRect(origin: CGPoint(x: 280,y :235), size: progressBar.size))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}


