//
//  Deck.swift
//  FlashCards
//
//  Created by Kevin Lu on 30/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import Foundation
import CoreData

class Deck : NSManagedObject {
    @NSManaged var name : String!
    @NSManaged var detail : String?
    @NSManaged var flashCards : NSSet?
    @NSManaged var subject : Subject!
    var useableFlashCards : [FlashCard]?
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(context : NSManagedObjectContext, name : String, detail : String?) {
        let entity = NSEntityDescription.entityForName("Deck", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        self.name = name
        if detail != nil {
            self.detail = detail
        }
    }
    
    func createFlashCards() {
        self.useableFlashCards = self.flashCards?.allObjects as? [FlashCard]
        self.shuffleDeck()
    }
    
    func shuffleDeck() {
        self.useableFlashCards?.shuffle((self.useableFlashCards?.count)!)
    }
    
    func getCard(index : Int) -> FlashCard {
        return self.useableFlashCards![index]
    }

}

import Foundation

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle(numberOfCards : Int)
    {
        for _ in 0..<numberOfCards
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}