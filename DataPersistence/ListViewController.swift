//
//  ListViewController.swift
//  DataPersistence
//
//  Created by Christoph Blattgerste on 06.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListViewController : UITableViewController {
    
    var overview : Overview!
    private var context : NSManagedObjectContext {
        return overview.managedObjectContext!
    }
    
    lazy var items : NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "List")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "created", ascending: false) ]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.overview.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "createBill":
                do {
                    try context.save()
                } catch {
                    print("Failed saving context: \(error)")
                }
            case "saveList":
                do {
                    try context.save()
                } catch {
                    print("Failed saving context: \(error)")
                }
            default:
                break
        }
    }
    @IBAction func unwindToBillsList(segue: UIStoryboardSegue) {
        if segue.identifier! == "addBill" {
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }
        }
    }
    

}

extension ListViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.sections?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListViewCell", forIndexPath: indexPath)
        let item = items.sections![indexPath.section].objects![indexPath.row] as! List
        cell.textLabel?.text = item.purpose
        cell.detailTextLabel?.text = item.money
        return cell
    }
}

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
