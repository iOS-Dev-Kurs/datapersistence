//
//  Gameday.swift
//  DataPersistence
//
//  Created by Colin Otchere on 11.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData

class Gameday: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var games: Set<Game>

}