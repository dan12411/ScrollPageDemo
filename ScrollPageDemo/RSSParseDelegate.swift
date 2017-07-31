//
//  RSSParseDelegate.swift
//  ScrollPageDemo
//
//  Created by 洪德晟 on 2017/7/31.
//  Copyright © 2017年 洪德晟. All rights reserved.
//

import Foundation

class RSSParseDelegate: NSObject, XMLParserDelegate {
    var currentItem: NewsItem?
    var currentElementValue: String?
    var resultArray = [NewsItem]()
    var timer = 0
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("****************************************")
        print("did start \(elementName)")
        if elementName == "item"{
            currentItem = NewsItem()
        } else if elementName == "title" {
            currentElementValue = nil
        } else if elementName == "link" {
            currentElementValue = nil
        } else if elementName == "pubData" {
            currentElementValue = nil
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("****************************************")
        print("did end \(elementName)")
        if elementName == "item"{
            if currentItem != nil {
                resultArray.append(currentItem!)
                currentItem = nil
            }
        } else if elementName == "title" {
            timer += 1
            if timer > 2 {
                currentItem?.title = currentElementValue
            }
        } else if elementName == "link" {
            if timer > 2 {
                currentItem?.link = currentElementValue
            }
        } else if elementName == "pubDate" {
            if timer > 2 {
                currentItem?.pubData = currentElementValue
            }
        }
        currentElementValue = nil
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("What: " + string)
        if currentElementValue == nil {
            currentElementValue = string
        } else {
            currentElementValue = currentElementValue! + string
        }
    }
    
    func getResult() -> [NewsItem] {
        return resultArray
    }
}

