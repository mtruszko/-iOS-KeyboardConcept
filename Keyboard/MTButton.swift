//
//  MTButton.swift
//  Keyboard-inz
//
//  Created by Marek on 30.12.2015.
//  Copyright © 2015 MT. All rights reserved.
//

import UIKit

class MTButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialie()
  
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialie()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialie()
    }
    
    func initialie() {
        
        setTitleColor(UIColor.keyColor(), forState: .Normal)
        backgroundColor = UIColor.backgroundColor()
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.keyColor().CGColor
        layer.cornerRadius = 5
        titleLabel?.font = UIFont.systemFontOfSize(15)
    }
}
