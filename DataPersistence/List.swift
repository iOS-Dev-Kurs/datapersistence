//
//  List.swift
//  DataPersistence
//
//  Created by Christoph Blattgerste on 06.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData

class List: NSManagedObject {
    
    @NSManaged var list : Overview
    @NSManaged var money : String
    @NSManaged var purpose : String
    @NSManaged var date : String
    @NSManaged var created : String
    
}
