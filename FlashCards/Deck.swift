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
    @NSManaged var flashCards : [FlashCard]?
    @NSManaged var subject : Subject!
    
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
    
}
