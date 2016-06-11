//
//  Team.swift
//  DataPersistence
//
//  Created by Colin Otchere on 11.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData

class Team: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var gruppe: String
    @NSManaged var pkt: Int

}