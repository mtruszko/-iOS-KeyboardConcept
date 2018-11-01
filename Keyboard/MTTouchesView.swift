//
//  MTTouchesView.swift
//  Keyboard-inz
//
//  Created by Marek on 17.11.2015.
//  Copyright © 2015 MT. All rights reserved.
//

import UIKit

protocol MTTouchesViewDeleagte {
    
    func touchesViewSending(touchesView: MTTouchesView, stringToShow: String)
}

class MTTouchesView: UIView {
    
    var delegate:MTTouchesViewDeleagte! = nil
    
//MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
//MARK: AddingKeyFIelds
    
    var arrayTreiangleView = [MTTriangleFieldView]()
    var circleView:MTCircleView!
    
    func addKeyboard(keyboard: MTKeyboard){
        
        clean()
        
        for filedKey in keyboard.arrayFileds {
            
            addSubview(makeTriangleFieldView(filedKey))
        }
        
        circleView = MTCircleView.init(parentBounds: bounds)
        addSubview(circleView)
    }
    
    
    func clean() {
        
//        for triangle in arrayTreiangleView {
//            
//            triangle.removeFromSuperview()
//        }
//        
//        circleView.removeFromSuperview()
        
        arrayTreiangleView.removeAll()
    }
    
    func makeTriangleFieldView(filedKey: MTFieldKey) -> MTTriangleFieldView{
        
        let triangleView = MTTriangleFieldView.init(field: filedKey, parentBounds: self.bounds)
        arrayTreiangleView.append(triangleView)
        
        return triangleView
    }
    
//MARK: Touches
    
    var arrayTouchedTriangleView = [MTTriangleFieldView]()
    var beginFromCircle:Bool = false
    var currentTouchedTriangleView:MTTriangleFieldView?
    var stringWord:String = ""

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if touches.count != 1 {
            
            return
        }
        
        if circleView.containPoint(touches.first!.locationInView(self)) {
            
            beginFromCircle = true
            return
        }
        
        if let touchedView:MTTriangleFieldView = touchedTriangleView(touches.first!) {
            
            touchedView.setSelected(true)
            arrayTouchedTriangleView.append(touchedView)
            
            currentTouchedTriangleView = touchedView
            showLetter()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        if touches.count != 1 {
        
            return
        }
        
        if circleView.containPoint(touches.first!.locationInView(self)) {
            
            if beginFromCircle {
                
                if arrayTouchedTriangleView.count != 0 {
                    
                    //powrociło
                    //ostatnia literka
                    
                    stringWord = stringWord + letterFromArray()
                    clearArrayTriangleViews()
                    
                }
                
                //jestesmy i machcamy w srodku
                //nie robimy nic
            }
            else {
                
                //weszło z literki, nie rob nic
                //czyszczenie przy wyjsciu
                clearArrayTriangleViews()

            }
            
            return
        }
        
        if let newTouchedView:MTTriangleFieldView = touchedTriangleView(touches.first!) {
            
            newTouchedView.setSelected(true)
            
            if newTouchedView != arrayTouchedTriangleView.last {
                
                arrayTouchedTriangleView.last?.setSelected(false)
                arrayTouchedTriangleView.append(newTouchedView)
                currentTouchedTriangleView = newTouchedView
                showLetter()
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if touches.count != 1{
            
            return
        }
        
        if circleView.containPoint(touches.first!.locationInView(self)) {
            
            if beginFromCircle {
                
                if arrayTouchedTriangleView.count != 0 {
                    
                    //powrociło
                    //ostatnia literk i spacja
                    
                    
                }
                
                sendLetter(stringWord + " ")
                stringWord = ""
                
            }
            else{
                
                //weszło z literki
                //literka i spacja
                choseLetter()
            }
            
            clearAll()
            showLetter()
            return
        }
        
        if let newTouchedView:MTTriangleFieldView = touchedTriangleView(touches.first!) {
            
            newTouchedView.setSelected(false)
            
            if beginFromCircle {
                
                stringWord = stringWord + letterFromArray()
                sendLetter(stringWord)
                stringWord = ""
                clearAll()
                showLetter()
                
                return
            }
    
            choseLetter()
            clearAll()
            showLetter()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
            clearAll()
    }
    
    
//MARK: Letter functions

    func touchedTriangleView(touch: UITouch) -> MTTriangleFieldView? {
        
        for view in arrayTreiangleView {
            
            if view.containPoint(touch.locationInView(self)) {
                
                return view
            }
        }
        
        return nil
    }
    
    func showLetter(){
        
        if currentTouchedTriangleView != nil {
            
            circleView.setLetter(letterFromArray())
        }
        else {
            
            circleView.setLetter("")
        }
    }
    
    func choseLetter () {
        
        if arrayTouchedTriangleView.count == 0 {
            
            if beginFromCircle{
                
                sendLetter(" ")
            }
            else {
                
                sendLetter((currentTouchedTriangleView?.field.tap)! + " ")
            }

            return
        }
        
        sendLetter(letterFromArray())
    }
    
    func letterFromArray() -> String {
        
        var letter = ""
        
        if arrayTouchedTriangleView.count == 1 {
            
            letter = arrayTouchedTriangleView.last!.field.tap
        }
        else if arrayTouchedTriangleView.count > 1 {
            
            let last = arrayTouchedTriangleView.last
            let prev = arrayTouchedTriangleView[arrayTouchedTriangleView.count - 2]
            
            if prev.field.point2 == last?.field.point1 {
                
                letter = prev.field.line2
            }
            else {
                
                letter = prev.field.line1
            }
            
            //external letter
            
            let l = chceckForExternalLetter()
            if l != "" {
                return l
            }
            
        }
        
        return letter
    }
    
    func chceckForExternalLetter() -> String {
        
        if arrayTouchedTriangleView.count > 2 {
            
            let last = arrayTouchedTriangleView.last
            let external = arrayTouchedTriangleView[arrayTouchedTriangleView.count - 3]
            
            if external.field.external != "" {
                
               return (last?.field.to)!
            }
        }
        
        return ""
    }
    
    func sendLetter(letter: String) {
        
        delegate!.touchesViewSending(self, stringToShow: letter)
    }
    
    func clearArrayTriangleViews() {
        
        for view in arrayTouchedTriangleView {
            
            view.setSelected(false)
        }
        
        arrayTouchedTriangleView.removeAll()
    }
    
    func clearAll() {
        
        clearArrayTriangleViews()
        currentTouchedTriangleView = nil
        beginFromCircle = false
    }
}
