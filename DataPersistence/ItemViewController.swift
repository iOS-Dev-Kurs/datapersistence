//
//  ItemViewController.swift
//  DataPersistence
//
//  Created by Arthur Heimbrecht on 13.6.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ItemViewController : UITableViewController{
	
	/// The list whose items to display
	var list: List!
	/// Shortcut for the list's context
	private var context: NSManagedObjectContext {
		return list.managedObjectContext!
	}
	
	lazy var items: NSFetchedResultsController = {
		let fetchRequest = NSFetchRequest(entityName: "To_Do_Thing")
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "importance", ascending: false) ]
		// We can also restrict the set of observed objects with a predicate:
		fetchRequest.predicate = NSPredicate(format: "list == %@", self.list)
		let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.list.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
		resultsController.delegate = self
		return resultsController
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		do {
			try items.performFetch()
		} catch {
			print("Failed fetching objects: \(error)")
		}
	}
	
	
	// MARK: User Interaction
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.identifier! {
		case "addItem":
			
			// Create edit context
			let editContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			editContext.parentContext = self.context
			
			// Retrieve list in edit context
			let editList = editContext.objectWithID(list.objectID) as! List
			
			// Pass edit context on to view controller
			let addItemController = (segue.destinationViewController as! UINavigationController).topViewController as! AddItemController
			addItemController.context = editContext
			addItemController.list = editList
			
		default:
			break
		}
	}
	
	@IBAction func unwindToItems(segue: UIStoryboardSegue) {
		switch segue.identifier! {
		case "saveItem":
			
			// Edit context was saved and changes propagated to main context, now save main context
			do {
				try context.save()
			} catch {
				print("Failed saving context: \(error)")
			}
			
		default:
			break
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let item = items.sections![indexPath.section].objects![indexPath.row] as! Item
		item.done = !item.done
		do {
			try context.save()
		} catch {
			print("Failed saving context: \(error)")
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
}


// MARK: - Table View Datasource

extension ItemViewController {
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return items.sections?.count ?? 0
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let section = items.sections![section]
		return section.numberOfObjects
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)
		let item = items.sections![indexPath.section].objects![indexPath.row] as! Item
		cell.textLabel?.text = item.name
		var importance: String
		switch item.importance{
		case 0: importance = "0"
		case 1: importance = "!"
		case 2: importance = "!!"
		case 3: importance = "!!!"
		default: importance = "x"
		}
		cell.detailTextLabel?.text = importance
		cell.textLabel?.textColor = item.done ? UIColor.lightGrayColor() : UIColor.darkTextColor()
		cell.accessoryType = item.done ? .Checkmark : .None
		return cell
	}
	
}


// MARK: - Table View Delegate

extension ItemViewController {
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		let item = items.sections![indexPath.section].objects![indexPath.row] as! Item
		context.deleteObject(item)
		do {
			try context.save()
		} catch {
			print("Failed saving context: \(error)")
		}
	}
	
}


// MARK: - Fetched Results Controller Delegate

extension ItemViewController: NSFetchedResultsControllerDelegate {
	
	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		tableView.beginUpdates()
	}
	
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		switch(type) {
		case .Insert:
			if let newIndexPath = newIndexPath {
				tableView.insertRowsAtIndexPaths([ newIndexPath ], withRowAnimation:.Automatic)
			}
		case .Delete:
			if let indexPath = indexPath {
				tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: .Automatic)
			}
		case .Update, .Move where newIndexPath == indexPath:
			if let indexPath = indexPath {
				tableView.reloadRowsAtIndexPaths([ indexPath ], withRowAnimation: .Automatic)
			}
		case .Move:
			if let indexPath = indexPath, let newIndexPath = newIndexPath where newIndexPath != indexPath {
				tableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
			}
		}
	}
	
	func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
		switch(type) {
		case .Insert:
			tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
		case .Delete:
			tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
		default:
			break
		}
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}
	
}