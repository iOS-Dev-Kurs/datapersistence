//
//  Overview.swift
//  DataPersistence
//
//  Created by Christoph Blattgerste on 06.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData

class Overview : NSManagedObject {
    
    @NSManaged var newMonth : String
    @NSManaged var listItem : Set<List>
    
}