//
//  Utility.swift
//  FlashCards
//
//  Created by Kevin Lu on 16/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit


class Utility {
    class func sharedInstance() -> Utility {
        struct Singleton {
            static let sharedInstance = Utility()
        }
        return Singleton.sharedInstance
    }
}

/*
let languageController = UIAlertController(title: "", message: "Select your language", preferredStyle: .ActionSheet)
let englishAction = UIAlertAction(title: "English", style: .Default) { action -> Void in
self.currentLanguage = .English
}
let chineseAction = UIAlertAction(title: "Chinese", style: .Default) { action -> Void in
self.currentLanguage = .Chinese
}
let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
// do nothing
}
languageController.addAction(englishAction)
languageController.addAction(chineseAction)
languageController.addAction(cancelAction)
self.presentViewController(languageController, animated: true, completion: nil)
*/
