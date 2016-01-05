//
//  NoteCollectionViewCell.swift
//  FlashCards
//
//  Created by Kevin Lu on 29/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit

class DeckCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deckNameLabel: UILabel!
    @IBOutlet weak var deckDetailLabel: UILabel!

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
