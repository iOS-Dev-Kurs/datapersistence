//
//  CreateItemViewController.swift
//  DataPersistence
//
//  Created by Nils Fischer on 03.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import UIKit
import CoreData

class CreateItemViewController: UIViewController {
    
    /// The context to save changes to. Should be a disposable child context of the main context.
    var context: NSManagedObjectContext!
    /// The list the created item should be associated to.
    var list: List!
    
    @IBOutlet var titleTextfield: UITextField!
    @IBOutlet var notesTextview: UITextView!
    
    
    // MARK: - User Interaction

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {

        case "saveItem":
            
            // Create item
            let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
            item.list = list
            item.title = titleTextfield.text ?? "Unnamed Item"
            item.notes = notesTextview.text
            
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
