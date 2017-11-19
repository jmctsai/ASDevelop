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
    
    @IBOutlet weak var RateDropdown: UIButton!
    @IBOutlet weak var ModulesDropdown: UIButton!
    
    @IBOutlet weak var RateTableView: UITableView!
    @IBOutlet weak var ModulesTableView: UITableView!
    
    var rateArray = [" By Game", " Daily", " Weekly"]
    var modulesArray = [" All Modules"]
    
    var studentIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change the View Header
        if instructor.students.count > studentIndex! {
            StudentProgressTitleField.text = (instructor.students[studentIndex!].firstName) + "'s Progress"
        }
        
        // Update the modules associated with current student
        modulesArray = [" All Modules"]
        for module in instructor.students[studentIndex!].modules {
            modulesArray.append(module.name)
        }
        
        self.RateTableView.dataSource = self
        self.RateTableView.delegate = self
        RateTableView.register(UITableViewCell.self, forCellReuseIdentifier: "rateCell")
        
        self.ModulesTableView.dataSource = self
        self.ModulesTableView.delegate = self
        ModulesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "modulesCell")
        
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if tableView == RateTableView {
            RateDropdown.setTitle(cell?.textLabel?.text, for: .normal)
            RateTableView.isHidden = true
        }
        
        if tableView == ModulesTableView {
            ModulesDropdown.setTitle(cell?.textLabel?.text, for: .normal)
            ModulesTableView.isHidden = true
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
    
    func updateGraphAxis(values: [Int]) {
        GraphYText0.text = String(values[0])
        GraphYText1.text = String(values[1])
        GraphYText2.text = String(values[2])
        GraphYText3.text = String(values[3])
        GraphYText4.text = String(values[4])
    }
}
