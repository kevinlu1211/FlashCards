//
//  HTMLScraper.swift
//  FlashCards
//
//  Created by Kevin Lu on 4/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class MDBGScraper {
    
    class func sharedInstance() -> MDBGScraper {
        struct Singleton {
            static var sharedInstance = MDBGScraper()
        }
        return Singleton.sharedInstance
    }

    
    func retrieveData(chineseWord : String) -> [String : [String]]{
        let baseURL = "http://chinesedictionary.mobi/?handler=QueryWorddict&mwdqb="
        let query = convertToUTF8Encoding(chineseWord)
        let urlString = baseURL + query
        let url = NSURL(string: urlString)!
        var dict = ["pinyin" : [String](), "definition" : [String]()]
        let dataObject = NSData(contentsOfURL: url)
        let doc = TFHpple(HTMLData: dataObject)
        
        // Scraping definition from source code
        if let pinyinArray = doc.searchWithXPathQuery("//td[@class='pinyin']") as? [TFHppleElement] {
            for pinyin in pinyinArray {
                let pinyinContent = pinyin.content
                let strippedPinyin = pinyinContent.stringByReplacingOccurrencesOfString("\n", withString: "")
                dict["pinyin"]?.append(strippedPinyin)
                
            }
        }
        
        // Scraping definition from source code
        if let definitionArray = doc.searchWithXPathQuery("//td[@class='english']") as? [TFHppleElement] {
            for definition in definitionArray {
                let definitionContent = definition.content
                let strippedDefinition = definitionContent.stringByReplacingOccurrencesOfString("\n", withString: "")
                dict["definition"]?.append(strippedDefinition)
            }
        }
        return dict
    }
    func convertToUTF8Encoding(chineseWord : String) -> String {
        let utf8EncodingForChineseWord = String(chineseWord.dataUsingEncoding(NSUTF8StringEncoding)!)
        print(utf8EncodingForChineseWord)
        let strippedString = stripString(utf8EncodingForChineseWord)
        var stringWithPercentages = ""
        var letterIndex = 0
        // Add percentage signs
        for char in strippedString.characters {
            if letterIndex == 0 || letterIndex % 2 == 0 {
                stringWithPercentages.append("%" as Character)
            }
            stringWithPercentages.append(char)
            letterIndex++
        }
        return stringWithPercentages
    }
    func stripString(string: String) -> String {
        var strippedString = string.stringByReplacingOccurrencesOfString("<", withString: "")
        strippedString = strippedString.stringByReplacingOccurrencesOfString(">", withString: "")
        strippedString = strippedString.stringByReplacingOccurrencesOfString(" ", withString: "")
        return strippedString
    }
}