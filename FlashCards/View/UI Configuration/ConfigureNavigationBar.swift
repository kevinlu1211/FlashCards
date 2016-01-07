//
//  ConfigureNavigationBar.swift
//  FlashCards
//
//  Created by Kevin Lu on 3/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit
extension UINavigationBar {
    func blackTransparentWithWhiteTint() {
        let navigationBarFontSize : CGFloat =  17.0
        let textAttributes = [
            NSFontAttributeName : UIFont(name: "FuturaLight", size: navigationBarFontSize)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        // Configure the navigation bar
        self.hidden = false
        self.titleTextAttributes = textAttributes
        self.tintColor = UIColor.whiteColor()
        self.barStyle = UIBarStyle.BlackOpaque
        self.translucent = true

    }
}



