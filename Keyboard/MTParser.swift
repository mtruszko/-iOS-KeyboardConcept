//
//  MTParser.swift
//  Keyboard-inz
//
//  Created by Marek on 22.11.2015.
//  Copyright © 2015 MT. All rights reserved.
//

import UIKit

enum MTPropertyType: String {
    
    case Keyboard = "keyboard"
    case Field = "field"
    case Points = "points"
    case Point1 = "point1"
    case Point2 = "point2"
    case X = "x"
    case Y = "y"
    case Tap = "tap"
    case Line1 = "line1"
    case Line2 = "line2"
    case External = "ext"
    case To = "to"

}

class MTParser: NSObject, NSXMLParserDelegate {

    var xmlParser: NSXMLParser?
    let path = NSBundle.mainBundle().pathForResource("ViewKey", ofType: "xml")
    
    func startParse(){
        
        if path != nil {
            
            xmlParser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: path!))
        }
        else {
            
            print("Fail To Find XML document")
            return
        }
        
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
//MARK: NSXMLParserDelegate
    
    var arrayKeyboard = [MTKeyboard]()
    var currentKeyboard:MTKeyboard!
    
    var currentParsedElement = String()
    //helper for duplicate keys
    var currentPoint = String()
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if let key = MTPropertyType(rawValue: elementName){
        
            switch key {
                
            case .Keyboard:
                currentKeyboard = MTKeyboard()
            case .Point1,
            .Point2:
                currentPoint = elementName
            default:
                break
            }
        }
        currentParsedElement = elementName
    }
    
    var entryPoint1x = String()
    var entryPoint2x = String()
    var entryPoint1y = String()
    var entryPoint2y = String()
    var entryTap = String()
    var entryLine1 = String()
    var entryLine2 = String()
    var entryExternal = String()
    var entryTo = String()
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
       
        if let key = MTPropertyType(rawValue: currentParsedElement) {
            
            switch key {
                
            case .Tap:
                entryTap = entryTap + string
            case .Line1:
                entryLine1 = entryLine1 + string
            case .Line2:
                entryLine2 = entryLine2 + string
            case .External:
                entryExternal = entryExternal + string
            case .To:
                entryTo = entryTo + string
            case .X:
                if currentPoint == MTPropertyType.Point1.rawValue{
                    
                    entryPoint1x = entryPoint1x + string
                }
                else{
                    
                    entryPoint2x = entryPoint2x  + string
                }
            case .Y:
                if currentPoint == MTPropertyType.Point1.rawValue{
                    
                    entryPoint1y =  entryPoint1y + string
                }
                else{
                    
                    entryPoint2y = entryPoint2y + string
                }
            default:
                break
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if let key = MTPropertyType(rawValue: elementName) {
            
            switch key {
                
            case .Keyboard:
                arrayKeyboard.append(currentKeyboard)
            case .Field:
        
                let fieldKey = MTFieldKey.init(letter: entryTap, point1: CGPointMake(entryPoint1x.CGFloatValue, entryPoint1y.CGFloatValue), point2: CGPointMake(entryPoint2x.CGFloatValue, entryPoint2y.CGFloatValue), tap: entryTap, line1: entryLine1, line2: entryLine2, external: entryExternal, to: entryTo)
                currentKeyboard.arrayFileds.append(fieldKey)
                
                entryPoint1x = ""
                entryPoint1y = ""
                entryPoint2x = ""
                entryPoint2y = ""
                entryLine1 = ""
                entryLine2 = ""
                entryTap = ""
                entryExternal = ""
                entryTo = ""
                
            case .Point1,
            .Point2:
                currentPoint = ""
            default:
                break
            }
        }
        currentParsedElement = ""
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        print("FinishedParse")
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("ERROR \(parseError)")
    }
}

extension String {
    var CGFloatValue: CGFloat {
        return CGFloat((self as NSString).doubleValue)
    }
}