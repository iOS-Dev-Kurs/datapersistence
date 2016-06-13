//
//  AddItemController.swift
//  DataPersistence
//
//  Created by Arthur Heimbrecht on 13.6.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddItemController : UIViewController{
	
	/// The context to save changes to. Should be a disposable child context of the main context.
	var context: NSManagedObjectContext!
	var list: List!
	
	@IBOutlet var titleTextfield: UITextField!
	@IBOutlet var importanceField: UISegmentedControl!
	
	
	// MARK: User Interaction
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.identifier! {
			
		case "saveItem":
			
			// Create list and set properties
			let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
			item.name = titleTextfield.text ?? "Unnamed Item"
			let importance = importanceField.selectedSegmentIndex
			//print(importance)
			item.importance = importance ?? 0
			item.list = list
			// Save context
			do {
				try context.save()
			} catch {
				print("Failed saving context: \(error)")
			}
			
		default:
			break
		}
	}

}