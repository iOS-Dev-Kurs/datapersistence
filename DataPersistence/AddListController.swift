//
//  AddListController.swift
//  DataPersistence
//
//  Created by Arthur Heimbrecht on 13.6.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddListController : UIViewController{
	
	/// The context to save changes to. Should be a disposable child context of the main context.
	var context: NSManagedObjectContext!
	
	@IBOutlet var titleTextfield: UITextField!
	
	
	// MARK: User Interaction
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.identifier! {
			
		case "saveList":
			
			// Create list and set properties
			let list = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context) as! List
			list.name = titleTextfield.text ?? "Unnamed List"
			
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