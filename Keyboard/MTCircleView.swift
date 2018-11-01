//
//  MTCircleView.swift
//  Keyboard-inz
//
//  Created by Marek on 30.12.2015.
//  Copyright © 2015 MT. All rights reserved.
//

import UIKit

class MTCircleView: UIView {

    var parentBounds:CGRect!
    var layerPath:UIBezierPath!
    var myLayer:CAShapeLayer!
    var label:UILabel!
    
    init(parentBounds: CGRect) {
        super.init(frame: parentBounds)
        
        self.parentBounds = parentBounds
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        
        layerPath = makeCircularPath()
        makeLayer()
        makeLabel()
        
    }
    
    func makeLabel() {
        
        label = UILabel.init()
        label.text = "_"
        label.textColor = UIColor.backgroundColor()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.sizeToFit()
        label.center = center
        label.isUserInteractionEnabled = false
        addSubview(label)
        
    }
    
    func makeLayer() {
        
        layer.masksToBounds = true
        
        let mask = CAShapeLayer()
        mask.frame = parentBounds
        mask.fillColor = UIColor.circleColor().cgColor
        mask.strokeColor = UIColor.backgroundColor().cgColor
        mask.lineWidth = 3
        mask.path = layerPath.cgPath
        self.layer.addSublayer(mask)
        myLayer = mask
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func makeCircularPath() -> UIBezierPath {
        
        let path = UIBezierPath.init(arcCenter: center, radius: parentBounds.height/5, startAngle: 0, endAngle: 9, clockwise: true)
        
        return path
    }
    
    func containPoint(point: CGPoint) -> Bool {
        
        if layerPath.contains(point) {
            
            return true
        }
        
        return false
    }
    
    func setLetter(letter: String) {
        
        if letter == ""{
         
            label.text = "_"
            label.sizeToFit()
            label.center = center
            return
        }
        
        label.text = letter
        label.sizeToFit()
        label.center = center
    }
    
    
    
}
