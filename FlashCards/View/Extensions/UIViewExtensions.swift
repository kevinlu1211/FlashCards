//
//  UIViewExtensions.swift
//  FlashCards
//
//  Created by Kevin Lu on 3/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn(duration : NSTimeInterval = 1.0, delay : NSTimeInterval = 0.0, alpha : CGFloat = 1.0, completion: ((Bool) -> Void)? = {(finished: Bool) -> Void in }) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {self.alpha = alpha}, completion: completion)
    }
    
    func fadeOut(duration : NSTimeInterval = 1.0, delay : NSTimeInterval = 0.0, alpha : CGFloat = 0.0, completion: ((Bool) -> Void)? = {(finished: Bool) -> Void in }) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.alpha = alpha}, completion: completion)
    }
}