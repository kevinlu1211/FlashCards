//
//  FlashCard.swift
//  FlashCards
//
//  Created by Kevin Lu on 30/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import Foundation
import CoreData

class FlashCard : NSManagedObject {
    @NSManaged var phrase : String
    @NSManaged var definition : String?
    @NSManaged var pronunciation : String?
    @NSManaged var deck : Deck?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(context : NSManagedObjectContext, phrase : String, pronunciation : String, definition : String) {
        let entity = NSEntityDescription.entityForName("FlashCard", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        self.phrase = phrase
        self.pronunciation = pronunciation
        self.definition = definition
        
        
    }
}