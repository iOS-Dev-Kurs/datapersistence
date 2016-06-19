//
//  ItemsViewController.swift
//  DataPersistence
//
//  Created by Nils Fischer on 03.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import UIKit
import CoreData

class ItemsViewController: UITableViewController {
    
    /// The list whose items to display
    var list: List!
    /// Shortcut for the list's context
    private var context: NSManagedObjectContext {
        return list.managedObjectContext!
    }
    
    lazy var items: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Item")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "created", ascending: false) ]
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
        case "createItem":
            
            // Create edit context
            let editContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            editContext.parentContext = self.context
            
            // Retrieve list in edit context
            let editList = editContext.objectWithID(list.objectID) as! List
            
            // Pass edit context on to view controller
            let createItemViewController = (segue.destinationViewController as! UINavigationController).topViewController as! CreateItemViewController
            createItemViewController.context = editContext
            createItemViewController.list = editList
            
            
        case "doneButton":
             // Reset Done things and increase weight.
             
            do {
            for item in list.items {
            if item.done {
            item.done = false
            item.doubleMaxiumWeight += 10
            }
            }
                
            list.lastDone = NSDate()
            try context.save()
             
             
            } catch {
            print("Failed saving context: \(error)")
            }
          
            

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

extension ItemsViewController {
    
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
        
        let workWeight = floor(CalculateWeight((item.doubleMaxiumWeight), repNumber: item.numberOfReps)/2)
        
        
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.numberOfLines = 2
        
        if item.large {
            cell.detailTextLabel?.text = "Warmup:   8x 40%:\(workWeight*0.4)kg  5x 60%: \(workWeight*0.6)kg  2x 80% \(workWeight*0.8)kg" + "\n" + "X Sets with \(workWeight) kg and \(item.numberOfReps) Reps"
        } else {
            cell.detailTextLabel?.text = "Warmup: 8x 50%:\(Float(item.doubleMaxiumWeight)/2)kg" + "\n" + "X Sets with \(workWeight) kg and \(item.numberOfReps) Reps"
        }
        
      
        cell.textLabel?.textColor = item.done ? UIColor.lightGrayColor() : UIColor.darkTextColor()
        cell.accessoryType = item.done ? .Checkmark : .None
        return cell
    }
    
}


// MARK: - Table View Delegate

extension ItemsViewController {
    
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

extension ItemsViewController: NSFetchedResultsControllerDelegate {
    
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
