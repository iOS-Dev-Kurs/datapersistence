//
//  GameListController.swift
//  DataPersistence
//
//  Created by Colin Otchere on 11.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GameListController: UITableViewController{
    
    var list: Gameday!
    var tournamentprogress: String = ""
    /// Shortcut for the list's context
    private var context: NSManagedObjectContext {
        return list.managedObjectContext!
    }
    
    lazy var items: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Game")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "created", ascending: false) ]
        // We can also restrict the set of observed objects with a predicate:
        fetchRequest.predicate = NSPredicate(format: "gameday == %@", self.list)
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.list.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tournamentprogress
        do {
            try items.performFetch()
        } catch {
            print("Failed fetching objects: \(error)")
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            
        case "createGame":
            
            // Create a disposable child context. Changes saved to this context are propagated as changes to the parent context. We may also discard the context, in which case any changes in it are also discarded.
            let editContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            editContext.parentContext = self.context
            
            let editList = editContext.objectWithID(list.objectID) as! Gameday

            // Pass edit context on to view controller
            let createListViewController = segue.destinationViewController as!
            CreateGameViewController
            createListViewController.context = editContext
            createListViewController.gameday = editList
            
        case "showDetail":
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let list = items.sections![indexPath.section].objects![indexPath.row] as! Game
            
            // Pass on selected list to detail view controller
            let itemsViewController = segue.destinationViewController as! DeatilViewController
            itemsViewController.list = list
            

        default:
            break
        }
    }
    

    @IBAction func unwindToGame(segue: UIStoryboardSegue) {
        switch segue.identifier! {
        case "saveGame":
            
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

extension GameListController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = items.sections![section]
        return section.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "GameCell"

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GameTableViewCell
        let item = items.sections![indexPath.section].objects![indexPath.row] as! Game
        cell.teamA.text = item.teamA
        cell.teamB.text = item.teamB
        return cell
    }
    
}


// MARK: - Table View Delegate

extension GameListController {
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let item = items.sections![indexPath.section].objects![indexPath.row] as! Game
        context.deleteObject(item)
        do {
            try context.save()
        } catch {
            print("Failed saving context: \(error)")
        }
    }
    
}


// MARK: - Fetched Results Controller Delegate

extension GameListController: NSFetchedResultsControllerDelegate {
    
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