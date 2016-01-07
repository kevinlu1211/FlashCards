//
//  ButtonExtension.swift
//  FlashCards
//
//  Created by Kevin Lu on 5/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func disableButton() {
        self.enabled = false
        self.setTitleColor(UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5), forState: .Normal)
    }
    
    func enableButton() {
        self.enabled = true
        self.setTitleColor(UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1), forState: .Normal)
    }

}