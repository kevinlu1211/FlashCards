//
//  Subject.swift
//  FlashCards
//
//  Created by Kevin Lu on 2/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import CoreData

class Subject : NSManagedObject {
    
    @NSManaged var name : String!
    @NSManaged var decks : [Deck]?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(context : NSManagedObjectContext, name : String) {
        let entity = NSEntityDescription.entityForName("Subject", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        self.name = name
    }

    
}