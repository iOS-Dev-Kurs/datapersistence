//
//  Game.swift
//  DataPersistence
//
//  Created by Colin Otchere on 11.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData

class Game: NSManagedObject {
    
    @NSManaged var gameday: Gameday
    @NSManaged var teamA: String
    @NSManaged var teamB: String
    @NSManaged var created: NSDate


    // Called when the object is created, i.e. inserted in a context
    override func awakeFromInsert() {
        super.awakeFromInsert()
        // Set attribute value as initial value, bypassing undo mechanics and such
        self.setPrimitiveValue(NSDate(), forKey: "created")
    }
}