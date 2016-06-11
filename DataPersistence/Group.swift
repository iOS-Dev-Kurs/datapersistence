//
//  Group.swift
//  DataPersistence
//
//  Created by Colin Otchere on 11.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData

class Group: NSManagedObject {
    
    @NSManaged var groupName: String
    @NSManaged var teams: Set<Team>

}