//: Playground - noun: a place where people can play

import UIKit

var str = "人家我她事誰"
let utf8Encoding = str.dataUsingEncoding(NSUTF8StringEncoding)
let newStr = String(utf8Encoding!)
convertToUTF8Encoding(newStr)


func convertToUTF8Encoding(string : String) {
    var letterCount = 0
    let lettersInUTF8Word = 6
    var chineseWord = ""
    var strippedString = string.stringByReplacingOccurrencesOfString("<", withString: "")
    strippedString = strippedString.stringByReplacingOccurrencesOfString(">", withString: "")
    strippedString = strippedString.stringByReplacingOccurrencesOfString(" ", withString: "")
    print(string)
    for char in string.characters {
        chineseWord.append(char)
        letterCount += 1
        if letterCount == lettersInUTF8Word {
            print(chineseWord)
            chineseWord = ""
        }
        
    }
}