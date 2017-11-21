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
        // Drop down menus only have 1 section
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the current dropdown menu is the rate
        if tableView == RateTableView {
            return rateArray.count
        }

        // Else is the current dropdown menu is the modules
        return modulesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        // If the dropdown is for rate
        if tableView == RateTableView {
            // Add the dropdown items to the rate table
            cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath)
            cell!.textLabel!.text = rateArray[indexPath.row]
        }
        
        // If the dropdown is for modules
        if tableView == ModulesTableView {
            // Add the dropdown items to the modules table
            cell = tableView.dequeueReusableCell(withIdentifier: "modulesCell", for: indexPath)
            cell!.textLabel!.text = modulesArray[indexPath.row]
        }
        
        // Set the text color and background
        cell!.textLabel!.textColor = UIColor.white
        cell!.backgroundColor = UIColor(hex: "1747BB")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        // If selected item is in the rate dropdown
        if tableView == RateTableView {
            
            // Set the dropdown button text to selected text
            RateDropdown.setTitle(" " + (cell?.textLabel?.text)!, for: .normal)
            RateTableView.isHidden = true
            rateSelection = indexPath.row
            
            // Redraw the selected progress graph
            drawProgressGraph()
        }
        
        // If the selected item is in the rate modules dropdown
        if tableView == ModulesTableView {
            
            // Set the dropdown button text to selected text
            ModulesDropdown.setTitle(" " + (cell?.textLabel?.text)!, for: .normal)
            ModulesTableView.isHidden = true
            modulesSelection = indexPath.row
            
            // Redraw the selected progress graph
            drawProgressGraph()
        }
    }
    
    // Hide or unhide the dropdown menu if dropdown button is pressed
    @IBAction func rateButtonPressed(_ sender: Any) {
        RateTableView.isHidden = !RateTableView.isHidden
    }
    
    // Hide or unhide the dropdown menu if dropdown button is pressed
    @IBAction func modulesButtonPressed(_ sender: Any) {
        ModulesTableView.isHidden = !ModulesTableView.isHidden
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //Go back to the student modules page
        dismiss(animated: true, completion: nil)
    }
    
    // Change the graph axis label based on the yValues provided and x axis array index
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
    
    // The logic to draw the progress graph based on the drop down menus selected
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
        
        // If By Game is selected
        if rateSelection == 0 {
            
            // Total games played for the current selected module on the drop down
            let xpCount = instructor.students[studentIndex!].modules[modulesSelection].timedXP.count
            
            // If there are less than or equal to 7 games played
            if xpCount - 7 <= 0 {
                var i = 0
                // Add the xp gained at each game to the yAxisXP array
                for xp in instructor.students[studentIndex!].modules[modulesSelection].timedXP.list {
                    yAxisXpArray[i] = xp
                    i = i + 1
                }
            }
            // More than 7 games played for currently selected module
            else
            {
                var j = 0
                // Get the last 7 games played for the currently selected module
                for i in xpCount - 7 ... xpCount - 1 {
                    yAxisXpArray[j] = instructor.students[studentIndex!].modules[modulesSelection].timedXP.list[i]
                    j = j + 1
                    
                }
            }

            // Set the maximum y axis xp value to 12
            yMax = 12
            
            // Size of the image graph area
            let yMaxPixel = 430.0
            let yMinPixel = 64.0
            
            // Get the image y coordinated for each value of xp
            for i in 0...6 {
                if yAxisXpArray[i] != -1 {
                    yAxisPosArray[i] = Int(((yMinPixel - yMaxPixel) / Double(yMax)) * Double(yAxisXpArray[i]) + yMaxPixel)
                }
            }
            
            // Change the graph axis labels
            updateGraphAxis(yValues: yAxisInt, xArray: rateSelection)
            
        }
        // TO BE COMPLETED IN VERSION 3
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
        
        // Draw the data points calculated onto the graph with connecting lines
        GraphImageView.image = drawGraph(graphImage: UIImage(named:"GraphTemplate.png")!, xPosArray: xAxisPosArray, yPosArray: yAxisPosArray)
    }
}

// Draw the data points and connecting lines onto the graph image using the x,y coordinates
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
