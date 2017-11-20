//
//  StudentProgressViewController.swift
//  ASDevelop
//
//  Created by lmulder on 2017-11-17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import FirebaseAuth

class StudentProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var StudentProgressTitleField: UILabel!
    @IBOutlet weak var GraphImageView: UIImageView!
    
    @IBOutlet weak var GraphYText4: UITextField!
    @IBOutlet weak var GraphYText3: UITextField!
    @IBOutlet weak var GraphYText2: UITextField!
    @IBOutlet weak var GraphYText1: UITextField!
    @IBOutlet weak var GraphYText0: UITextField!
    
    @IBOutlet weak var GraphXText6: UITextField!
    @IBOutlet weak var GraphXText5: UITextField!
    @IBOutlet weak var GraphXText4: UITextField!
    @IBOutlet weak var GraphXText3: UITextField!
    @IBOutlet weak var GraphXText2: UITextField!
    @IBOutlet weak var GraphXText1: UITextField!
    @IBOutlet weak var GraphXText0: UITextField!
    
    @IBOutlet weak var RateDropdown: UIButton!
    @IBOutlet weak var ModulesDropdown: UIButton!
    
    @IBOutlet weak var RateTableView: UITableView!
    @IBOutlet weak var ModulesTableView: UITableView!
    
    var rateSelection = 0
    var modulesSelection = 0
    
    var rateArray = ["By Game", "Daily", "Weekly"]
    var modulesArray = [String]()
    
    var xAxisArray = [["G1", "G2", "G3", "G4", "G5", "G6", "G7"], [""], ["W1", "W2", "W3", "W4", "W5", "W6", "W7"]]
    let dayNameArray = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    var studentIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change the View Header
        if instructor.students.count > studentIndex! {
            StudentProgressTitleField.text = (instructor.students[studentIndex!].firstName) + "'s Progress"
        }
        
        // Update the modules associated with current student
        modulesArray = [String]()
        for module in instructor.students[studentIndex!].modules {
            modulesArray.append(module.name)
        }
        
        if modulesArray.count > 0 {
            ModulesDropdown.setTitle(" " + modulesArray[0], for: .normal)
        }
        
        var currentDayNameArray = dayNameArray
        let day = Date().dayNumberOfWeek()!
        for i in 0...6 {
            currentDayNameArray[i] = dayNameArray[(day + i) % 7]
        }
        xAxisArray[1] = currentDayNameArray
        
        self.RateTableView.dataSource = self
        self.RateTableView.delegate = self
        RateTableView.register(UITableViewCell.self, forCellReuseIdentifier: "rateCell")
        
        self.ModulesTableView.dataSource = self
        self.ModulesTableView.delegate = self
        ModulesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "modulesCell")
        
        /*
        var bounds = RateTableView.frame
        RateTableView.frame = CGRect(x: bounds.origin.x,
                                      y: bounds.origin.y,
                                      width: bounds.size.width,
                                      height: CGFloat(39 * rateArray.count))
        
        bounds = ModulesTableView.frame
        ModulesTableView.frame = CGRect(x: bounds.origin.x,
                                         y: bounds.origin.y,
                                         width: bounds.size.width,
                                         height: CGFloat(39 * modulesArray.count))
        */
        
        var px = 1 / UIScreen.main.scale
        var frame = CGRect(x: 0, y: 0,width:  RateTableView.frame.size.width, height: px)
        var line = UIView(frame: frame)
        RateTableView.tableHeaderView = line
        line.backgroundColor = RateTableView.separatorColor
        
        px = 1 / UIScreen.main.scale
        frame = CGRect(x: 0, y: 0,width:  ModulesTableView.frame.size.width, height: px)
        line = UIView(frame: frame)
        ModulesTableView.tableHeaderView = line
        line.backgroundColor = ModulesTableView.separatorColor
        
        ModulesTableView.isHidden = true
        RateTableView.isHidden = true
        
        drawProgressGraph()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == RateTableView {
            return rateArray.count
        }

        return modulesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        if tableView == RateTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath)
            cell!.textLabel!.text = rateArray[indexPath.row]
        }
        
        if tableView == ModulesTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "modulesCell", for: indexPath)
            cell!.textLabel!.text = modulesArray[indexPath.row]
        }
        
        cell!.textLabel!.textColor = UIColor.white
        cell!.backgroundColor = UIColor(hex: "1747BB")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if tableView == RateTableView {
            RateDropdown.setTitle(" " + (cell?.textLabel?.text)!, for: .normal)
            RateTableView.isHidden = true
            rateSelection = indexPath.row
            drawProgressGraph()
        }
        
        if tableView == ModulesTableView {
            ModulesDropdown.setTitle(" " + (cell?.textLabel?.text)!, for: .normal)
            ModulesTableView.isHidden = true
            modulesSelection = indexPath.row
            drawProgressGraph()
        }
    }
    
    @IBAction func rateButtonPressed(_ sender: Any) {
        RateTableView.isHidden = !RateTableView.isHidden
    }
    
    @IBAction func modulesButtonPressed(_ sender: Any) {
        ModulesTableView.isHidden = !ModulesTableView.isHidden
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //Send Student Data Back
        dismiss(animated: true, completion: nil)
    }
    
    func updateGraphAxis(yValues: [Int], xArray : Int) {
        GraphYText0.text = String(yValues[0])
        GraphYText1.text = String(yValues[1])
        GraphYText2.text = String(yValues[2])
        GraphYText3.text = String(yValues[3])
        GraphYText4.text = String(yValues[4])
        
        GraphXText0.text = String(xAxisArray[xArray][0])
        GraphXText1.text = String(xAxisArray[xArray][1])
        GraphXText2.text = String(xAxisArray[xArray][2])
        GraphXText3.text = String(xAxisArray[xArray][3])
        GraphXText4.text = String(xAxisArray[xArray][4])
        GraphXText5.text = String(xAxisArray[xArray][5])
        GraphXText6.text = String(xAxisArray[xArray][6])
 
    }
    
    func drawProgressGraph() {
        var yMax = 0

        var yAxisXpArray = [-1, -1, -1, -1, -1, -1, -1]
        var yAxisPosArray = [-1, -1, -1, -1, -1, -1, -1]
        let xAxisPosArray = [145, 252, 356, 467, 570, 675, 787]
        var yAxisInt = [0, 3, 6, 9, 12]
        
        if instructor.students[studentIndex!].modules.count == 0 {
            GraphImageView.image = UIImage(named:"GraphTemplate.png")!
            return
        }
        else
        {
            if instructor.students[studentIndex!].modules[modulesSelection].xp == 0 && instructor.students[studentIndex!].modules[modulesSelection].level == 0 {
                GraphImageView.image = UIImage(named:"GraphTemplate.png")!
                return
            }
        }
        
        if rateSelection == 0 {
            
            let xpCount = instructor.students[studentIndex!].modules[modulesSelection].timedXP.count
            
            if xpCount - 7 <= 0 {
                var i = 0
                for xp in instructor.students[studentIndex!].modules[modulesSelection].timedXP.list {
                    yAxisXpArray[i] = xp
                    i = i + 1
                }
            }
            else
            {
                var j = 0
                for i in xpCount - 7 ... xpCount - 1 {
                    yAxisXpArray[j] = instructor.students[studentIndex!].modules[modulesSelection].timedXP.list[i]
                    j = j + 1
                    
                }
            }

            yMax = 12
            
            let yMaxPixel = 430.0
            let yMinPixel = 64.0
            
            for i in 0...6 {
                if yAxisXpArray[i] != -1 {
                    yAxisPosArray[i] = Int(((yMinPixel - yMaxPixel) / Double(yMax)) * Double(yAxisXpArray[i]) + yMaxPixel)
                }
            }
            
            updateGraphAxis(yValues: yAxisInt, xArray: rateSelection)
            
        }
        else if rateSelection == 1
        {
            let maxXp = 0
            
            if maxXp <= 10 {
                yMax = 12
            }
            else {
                yMax = Int(Double(maxXp) / Double(4)) * 4 + 4
            }
            
            for i in 1...4 {
                yAxisInt[i] = (yMax / 4) * i
            }
            
            if maxXp <= 10 || rateSelection == 0 {
                yMax = 12
            }
            else {
                yMax = Int(Double(maxXp) / Double(4)) * 4 + 4
            }
            
            for i in 1...4 {
                yAxisInt[i] = (yMax / 4) * i
            }
        }
        
        GraphImageView.image = drawGraph(graphImage: UIImage(named:"GraphTemplate.png")!, xPosArray: xAxisPosArray, yPosArray: yAxisPosArray)
    }
}

func drawGraph(graphImage: UIImage, xPosArray: [Int], yPosArray: [Int]) -> UIImage {
    
    if yPosArray[0] == -1 {
        return graphImage
    }
    
    // Create a context of the starting image size and set it as the current one
    UIGraphicsBeginImageContext(graphImage.size)
    
    // Draw the starting image in the current context as background
    graphImage.draw(at: CGPoint.zero)
    
    // Get the current context
    let context = UIGraphicsGetCurrentContext()!
    
    for i in 1...yPosArray.count - 1 {
        if yPosArray[i] == -1 {
            break
        }
        
        // Draw a blue connecting line
        context.setLineWidth(3.0)
        context.setStrokeColor(UIColor(hex: "1747BB").cgColor)
        context.move(to: CGPoint(x: xPosArray[i-1], y: yPosArray[i-1]))
        context.addLine(to: CGPoint(x: xPosArray[i], y: yPosArray[i]))
        context.strokePath()
    }
    
    for i in 0...yPosArray.count - 1 {
        if yPosArray[i] == -1 {
            break
        }
        
        // Draw a grey dot
        context.setStrokeColor(UIColor(hex: "CED5E7").cgColor)
        context.setAlpha(1.0)
        context.setLineWidth(16.0)
        context.addEllipse(in: CGRect(x: xPosArray[i] - 8, y: yPosArray[i] - 8, width: 16, height: 16))
        context.drawPath(using: .fillStroke)
        
        // Draw a blue dot
        context.setStrokeColor(UIColor(hex: "1747BB").cgColor)
        context.setAlpha(1.0)
        context.setLineWidth(10.0)
        context.addEllipse(in: CGRect(x: xPosArray[i] - 5, y: yPosArray[i] - 5, width: 10, height: 10))
        context.drawPath(using: .fillStroke)
    }
    
    // Save the context as a new UIImage
    let myImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    // Return modified image
    return myImage!
}
