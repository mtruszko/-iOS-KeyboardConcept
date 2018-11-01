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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customInterface)
        
        if let parser:MTParser = MTParser() {
            
            parser.startParse()
            print("\(parser.arrayKeyboard)")
            keybord = parser.arrayKeyboard[0]
        }
        
        addNextKeyboardButton()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let myKeyboard = keybord {
            
            touchesView.addKeyboard(myKeyboard)
            touchesView.delegate = self
        }
    }

    
    var customInterface: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiateWithOwner(self, options: nil)
        
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
                
                shiftButton.selected = true
            }
            else {
                
                shiftButton.selected = false
            }
            
            
            
        default:
            
            insertTextToKeyboard(stringLabel)
        }
       
    }
    
    func touchesViewSending(touchesView: MTTouchesView, stringToShow: String) {
        
        insertTextToKeyboard(stringToShow)
    }
    
    func insertTextToKeyboard(text: String) {
            
        if boolShift {
            
            textDocumentProxy.insertText(text.capitalizeFirst)
            boolShift = !boolShift
            shiftButton.selected = false
        }
        else {
            
            textDocumentProxy.insertText(text)
        }
            
    }
        
    func addNextKeyboardButton() {
        
        self.nextKeyboardButton = MTButton(frame: CGRectZero)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
//        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }
}

extension String {
    
    var capitalizeFirst: String {
        if isEmpty { return "" }
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).uppercaseString)
        return result
    }
    
}
