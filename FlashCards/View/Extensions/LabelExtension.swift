//
//  CollectionViewCellExtension.swift
//  FlashCards
//
//  Created by Kevin Lu on 3/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func configureCollectionViewCellLabel(labelText : String, fontName : String = "FuturaLight", size : Double = 17.0, color : UIColor = UIColor.blackColor()) {
        self.text = labelText
        self.font = UIFont(name: fontName, size: CGFloat(size))
        self.textColor = color
    }
}