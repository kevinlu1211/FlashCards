//
//  CardCollectionViewCell.swift
//  FlashCards
//
//  Created by Kevin Lu on 2/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var pronunciationLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
