//
//  List.swift
//  DataPersistence
//
//  Created by Nils Fischer on 03.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData

class List: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var items: Set<Item>
    @NSManaged var lastDone: NSDate
    
    
    
    // Called when the object is created, i.e. inserted in a context
    override func awakeFromInsert() {
        super.awakeFromInsert()
        // Set attribute value as initial value, bypassing undo mechanics and such
        self.setPrimitiveValue(NSDate(), forKey: "lastDone")
    }
}
