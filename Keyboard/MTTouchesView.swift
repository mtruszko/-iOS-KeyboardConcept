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
            
            addSubview(makeTriangleFieldView(filedKey: filedKey))
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if touches.count != 1 {
            
            return
        }
        
        if circleView.containPoint(point: touches.first!.location(in: self)) {
            
            beginFromCircle = true
            return
        }
        
        if let touchedView:MTTriangleFieldView = touchedTriangleView(touch: touches.first!) {
            
            touchedView.setSelected(selected: true)
            arrayTouchedTriangleView.append(touchedView)
            
            currentTouchedTriangleView = touchedView
            showLetter()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if touches.count != 1 {
        
            return
        }
        
        if circleView.containPoint(point: touches.first!.location(in: self)) {
            
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
        
        if let newTouchedView:MTTriangleFieldView = touchedTriangleView(touch: touches.first!) {
            
            newTouchedView.setSelected(selected: true)
            
            if newTouchedView != arrayTouchedTriangleView.last {
                
                arrayTouchedTriangleView.last?.setSelected(selected: false)
                arrayTouchedTriangleView.append(newTouchedView)
                currentTouchedTriangleView = newTouchedView
                showLetter()
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if touches.count != 1{
            
            return
        }
        
        if circleView.containPoint(point: touches.first!.location(in: self)) {
            
            if beginFromCircle {
                
                if arrayTouchedTriangleView.count != 0 {
                    
                    //powrociło
                    //ostatnia literk i spacja
                    
                    
                }
                
                sendLetter(letter: stringWord + " ")
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
        
        if let newTouchedView:MTTriangleFieldView = touchedTriangleView(touch: touches.first!) {
            
            newTouchedView.setSelected(selected: false)
            
            if beginFromCircle {
                
                stringWord = stringWord + letterFromArray()
                sendLetter(letter: stringWord)
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
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches!, with: event)
        
            clearAll()
    }
    
    
//MARK: Letter functions

    func touchedTriangleView(touch: UITouch) -> MTTriangleFieldView? {
        
        for view in arrayTreiangleView {
            
            if view.containPoint(point: touch.location(in: self)) {
                
                return view
            }
        }
        
        return nil
    }
    
    func showLetter(){
        
        if currentTouchedTriangleView != nil {
            
            circleView.setLetter(letter: letterFromArray())
        }
        else {
            
            circleView.setLetter(letter: "")
        }
    }
    
    func choseLetter () {
        
        if arrayTouchedTriangleView.count == 0 {
            
            if beginFromCircle{
                
                sendLetter(letter: " ")
            }
            else {
                
                sendLetter(letter: (currentTouchedTriangleView?.field.tap)! + " ")
            }

            return
        }
        
        sendLetter(letter: letterFromArray())
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
        
        delegate!.touchesViewSending(touchesView: self, stringToShow: letter)
    }
    
    func clearArrayTriangleViews() {
        
        for view in arrayTouchedTriangleView {
            
            view.setSelected(selected: false)
        }
        
        arrayTouchedTriangleView.removeAll()
    }
    
    func clearAll() {
        
        clearArrayTriangleViews()
        currentTouchedTriangleView = nil
        beginFromCircle = false
    }
}
