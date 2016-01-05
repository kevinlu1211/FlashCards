//
//  ConfigureCollectionView.swift
//  FlashCards
//
//  Created by Kevin Lu on 3/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func configureCollectionView() {
        
        // Set background image
        self.backgroundColor = UIColor(patternImage: UIImage(named: "woodenBackground")!)
        
        // Create the layout
        let space = 10.0 as CGFloat
        let flowLayout = UICollectionViewFlowLayout()
        let width = (self.superview!.frame.size.width - (2 * space))
        let height = (self.superview!.frame.size.height - (2 * space))/6
        let edgeInsets = UIEdgeInsetsMake(space, 0, space, 0)
        // Set left and right margins
        flowLayout.minimumInteritemSpacing = space
        
        // Set top and bottom margins
        flowLayout.minimumLineSpacing = space
        
        
        // Set edge insets
        flowLayout.sectionInset = edgeInsets
        
        flowLayout.itemSize = CGSizeMake(width, height)
        
        self.setCollectionViewLayout(flowLayout, animated: true)
    }

}