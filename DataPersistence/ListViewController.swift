//
//  ListViewController.swift
//  DataPersistence
//
//  Created by Arthur Heimbrecht on 13.6.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListViewController : UITableViewController{
	/// The connection to the database
	var context: NSManagedObjectContext!
	
	/// Fetches objects from the database and observes changes
	private lazy var lists: NSFetchedResultsController = {
		// The fetch request defines the subset of objects to fetch
		let fetchRequest = NSFetchRequest(entityName: "List")
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
		// Create the fetched results controller with the fetch request
		let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
		// The delegate can react to changes in the set of fetched objects
		resultsController.delegate = self
		return resultsController
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// We need to perform an initial fetch before changes will be observed
		do {
			try lists.performFetch()
		} catch {
			print("Failed fetching objects: \(error)")
		}
	}
	
	
	// MARK: User Interaction
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.identifier! {
			
		case "addList":
			
			// Create a disposable child context. Changes saved to this context are propagated as changes to the parent context. We may also discard the context, in which case any changes in it are also discarded.
			let editContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			editContext.parentContext = self.context
			
			// Pass edit context on to view controller
			let addListController = (segue.destinationViewController as! UINavigationController).topViewController as! AddListController
			addListController.context = editContext
			
		case "showItems":
			
			// Retrieve selected list
			guard let indexPath = tableView.indexPathForSelectedRow else { return }
			let list = lists.sections![indexPath.section].objects![indexPath.row] as! List
			
			// Pass on selected list to detail view controller
			let itemViewController = segue.destinationViewController as! ItemViewController
			itemViewController.list = list
			
		default:
			break
		}
	}
	
	@IBAction func unwindToLists(segue: UIStoryboardSegue) {
		switch segue.identifier! {
		case "saveList":
			
			// Edit context was saved and changes propagated to main context. Now save main context to persist the changes to the persistent store.
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


// MARK: - Table View Datasource

extension ListViewController {
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return lists.sections?.count ?? 0
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let section = lists.sections![section]
		return section.numberOfObjects
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath)
		let list = lists.sections![indexPath.section].objects![indexPath.row] as! List
		cell.textLabel?.text = list.name
		cell.detailTextLabel?.text = String(list.items.count)
		return cell
	}
	
}


// MARK: - Table View Delegate

extension ListViewController {
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		let list = lists.sections![indexPath.section].objects![indexPath.row] as! List
		context.deleteObject(list)
		do {
			try context.save()
		} catch {
			print("Failed saving context: \(error)")
		}
	}
	
}


// MARK: - Fetched Results Controller Delegate

extension ListViewController: NSFetchedResultsControllerDelegate {
	
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