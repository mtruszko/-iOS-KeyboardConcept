//
//  ViewController.swift
//  Keyboard-inz
//
//  Created by Marek on 21.10.2015.
//  Copyright © 2015 MT. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target:self, action:"dismissKeyboard"))
        
//        textField.becomeFirstResponder()
        
    }
    
    func dismissKeyboard() {
        
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

