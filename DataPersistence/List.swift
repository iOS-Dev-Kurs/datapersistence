//
//  List.swift
//  DataPersistence
//
//  Created by Arthur Heimbrecht on 13.6.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData

class List : NSManagedObject {
	
	@NSManaged var name: String
	@NSManaged var no_items: Int
	@NSManaged var Set<Item>

}