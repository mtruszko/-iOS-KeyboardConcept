//
//  MTFieldKey.swift
//  Keyboard-inz
//
//  Created by Marek on 27.12.2015.
//  Copyright © 2015 MT. All rights reserved.
//

import UIKit

class MTFieldKey: NSObject {

    var letter:String = ""
    var point1 = CGPointMake(0, 0)
    var point2 = CGPointMake(0, 0)
    var tap = ""
    var line1 = ""
    var line2 = ""
    var external = ""
    var to = ""
    
    init(letter: String, point1: CGPoint, point2: CGPoint, tap: String, line1: String, line2: String, external: String, to :String){
        
        self.letter = letter
        self.point1 = point1
        self.point2 = point2
        self.tap = tap
        self.line1 = line1
        self.line2 = line2
        self.external = external
        self.to = to
        
    }

}
