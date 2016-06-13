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
	
	@NSManaged var list: List
	@NSManaged var name: String
	@NSManaged var created: NSDate
	@NSManaged var importance: Int
	@NSManaged var done: Bool

	
	// Called when the object is created, i.e. inserted in a context
	override func awakeFromInsert() {
		super.awakeFromInsert()
		// Set attribute value as initial value, bypassing undo mechanics and such
		self.setPrimitiveValue(NSDate(), forKey: "created")
	}
}