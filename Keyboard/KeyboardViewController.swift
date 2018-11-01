//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Marek on 21.10.2015.
//  Copyright © 2015 MT. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, MTTouchesViewDeleagte {

    @IBOutlet var nextKeyboardButton: MTButton!

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    var keybord:MTKeyboard?
    @IBOutlet weak var touchesView: MTTouchesView!
    
    let parser = MTParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customInterface)
        
        parser.startParse {
            print("\(self.parser.arrayKeyboard)")
            self.keybord = self.parser.arrayKeyboard[0]
        }
        
        addNextKeyboardButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let myKeyboard = keybord {
            
            touchesView.addKeyboard(keyboard: myKeyboard)
            touchesView.delegate = self
        }
    }

    
    var customInterface: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        
        customInterface = objects.last as! UIView
        customInterface.frame = view.bounds
        customInterface.backgroundColor = UIColor.backgroundColor()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var boolShift:Bool = false
    @IBOutlet weak var shiftButton: MTButton!
    
    @IBAction func tapButtonKeyboard(sender: AnyObject) {
        
        let button = sender as! MTButton
        
        let stringLabel:String = (button.titleLabel?.text)!
        
        switch stringLabel {
        case "<":
            
            textDocumentProxy.deleteBackward()
            
            
        case "\\":
            
            textDocumentProxy.insertText("\n")
            
        case "^":
            
            boolShift = !boolShift
            
            if boolShift {
                
                shiftButton.isSelected = true
            }
            else {
                
                shiftButton.isSelected = false
            }
            
            
            
        default:
            
            insertTextToKeyboard(text: stringLabel)
        }
       
    }
    
    func touchesViewSending(touchesView: MTTouchesView, stringToShow: String) {
        
        insertTextToKeyboard(text: stringToShow)
    }
    
    func insertTextToKeyboard(text: String) {
            
        if boolShift {
            
            textDocumentProxy.insertText(text.capitalizeFirst)
            boolShift = !boolShift
            shiftButton.isSelected = false
        }
        else {
            
            textDocumentProxy.insertText(text)
        }
            
    }
        
    func addNextKeyboardButton() {
        
        self.nextKeyboardButton = MTButton(frame: CGRect.zero)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: .normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .touchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
//        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }
}

extension String {
    var capitalizeFirst: String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
}
