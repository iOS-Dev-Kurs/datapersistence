//
//  OverviewViewController.swift
//  DataPersistence
//
//  Created by Christoph Blattgerste on 06.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class OverviewViewController: UITableViewController {
    
//    Connection to database
    var context: NSManagedObjectContext!

//    keeps database up to date
    private lazy var overviews: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Overview")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "newMonth", ascending: true) ]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try overviews.performFetch()
        } catch {
            print("Failed fetching objects: \(error)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "showDetailList":
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                let overview = overviews.sections![indexPath.section].objects![indexPath.row] as! Overview
                let listVC = segue.destinationViewController as! ListViewController
                listVC.overview = overview
                listVC.title = overview.newMonth
            case "createNewMonth":
                do {
                    try context.save()
                } catch {
                    print("Failed saving context: \(error)")
                }
            default:
                break
        }
    }
    
    @IBAction func unwindToOverview(segue: UIStoryboardSegue) {
        switch segue.identifier! {
        case "saveList" :
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }
        case "saveNewMonth":
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

extension OverviewViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overviews.sections?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell", forIndexPath: indexPath)
        let overview = overviews.sections![indexPath.section].objects![indexPath.row] as! Overview
        cell.textLabel?.text = overview.newMonth
        cell.detailTextLabel?.text = String(overview.listItem.count)
        return cell
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

extension OverviewViewController : NSFetchedResultsControllerDelegate {
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
