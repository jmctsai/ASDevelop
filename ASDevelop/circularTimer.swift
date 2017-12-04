//
//  circularTimer.swift
//  ASDevelop
//
//  Created by jiamengd on 12/4/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class circularTimer: UIView {
    
    var value: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
     
    var maximumValue: CGFloat = 0 {
        didSet { self.setNeedsDisplay() } 
    }
    override init(frame: CGRect) {
        super.init(frame: frame)  
        self.backgroundColor = UIColor.red
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        let timerColor = UIColor(red:0.12, green:0.51, blue:0.91, alpha:1.0)
        
        
        let lineWidth: CGFloat = 15.0
        
        let radius: CGFloat = rect.width / 2.0 - lineWidth
        
        let centerX = rect.midX
        
        let centerY = rect.midY
        
        let startAngle = CGFloat(-90 * Double.pi / 180)
        
        let endAngle = CGFloat(((self.value / self.maximumValue) * 360.0 - 90.0) ) * CGFloat(Double.pi) / 180.0
        
        
        let context = UIGraphicsGetCurrentContext()
        
        context!.setLineWidth(lineWidth)
        
        context!.setStrokeColor(timerColor.cgColor)
        
        //draw clockwise
        context?.addArc(center: CGPoint(x:centerX,y:centerY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        context!.strokePath()
    }
    
}

