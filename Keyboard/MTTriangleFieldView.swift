//
//  MTTriangleFieldView.swift
//  Keyboard-inz
//
//  Created by Marek on 27.12.2015.
//  Copyright © 2015 MT. All rights reserved.
//

import UIKit

class MTTriangleFieldView: UIView {

    var field:MTFieldKey!
    var parentBounds:CGRect!
    var layerPath:UIBezierPath!
    var myLayer:CAShapeLayer!
    var middlePoint:CGPoint!
    var label:UILabel!

    init(field: MTFieldKey, parentBounds: CGRect) {
        super.init(frame: parentBounds)
        
        self.field = field
        self.parentBounds = parentBounds
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        
        layerPath = makeTriangularPath()
        makeLayer()
        makeLabel()

    }
    
    func makeLabel() {
        
        label = UILabel.init()
        
        if middlePoint.y > parentBounds.height/2 {
            
            label.text = field.line2 + " " + field.tap + " " + field.line1
            
            if field.external != "" {
                
                label.text = field.external + "\n" + field.line2 + " " + field.tap + " " + field.line1
            }
        }
        else {
         
            label.text = field.line1 + " " + field.tap + " " + field.line2
            
            if field.external != "" {
                
                label.text = field.line1 + " " + field.tap + " " + field.line2 + "\n" + field.external
            }
        }
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.center = middlePoint
        label.textColor = UIColor.backgroundColor()
        label.isUserInteractionEnabled = false
        addSubview(label)

    }
    
    func makeLayer() {
        
        layer.masksToBounds = true

        let mask = CAShapeLayer()
        mask.frame = parentBounds
        mask.fillColor = UIColor.keyColor().cgColor
        mask.strokeColor = UIColor.backgroundColor().cgColor
        mask.lineWidth = 3
        mask.path = layerPath.cgPath
        self.layer.addSublayer(mask)
        myLayer = mask
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func makeTriangularPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        
        let point0 = CGPoint(x: parentBounds.width/2, y: parentBounds.height/2)
        let point1 = CGPoint(x: parentBounds.width * field.point1.x, y: parentBounds.height * field.point1.y)
        let point2 = CGPoint(x: parentBounds.width * field.point2.x, y: parentBounds.height * field.point2.y)
        
        middlePoint = CGPoint(x: (point0.x + point1.x + point2.x)/3, y: (point0.y + point1.y + point2.y)/3)
        
        path.move(to: point0)
        path.addLine(to: point1)
        path.addLine(to: point2)
        path.close()

        return path
    }
    
    func containPoint(point: CGPoint) -> Bool {
        
        if layerPath.contains(point) {

            return true
        }
        
        return false
    }
    
    func setSelected(selected: Bool){
        
        if  selected {
            
            myLayer.fillColor = UIColor.keySelectedColor().cgColor
        }
        else {
            
            myLayer.fillColor = UIColor.keyColor().cgColor
        }
        
    }
}
