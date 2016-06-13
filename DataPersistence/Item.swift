//
//  Item.swift
//  DataPersistence
//
//  Created by Arthur Heimbrecht on 13.6.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData

class Item : NSManagedObject {
	
	@NSManaged var name: String
	@NSManaged var date: NSDate
	@NSManaged var importance: Int
	@NSManaged var done: Bool
	
}