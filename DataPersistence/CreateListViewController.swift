//
//  CreateListViewController.swift
//  DataPersistence
//
//  Created by Nils Fischer on 03.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import UIKit
import CoreData

class CreateListViewController: UIViewController {
    
    /// The context to save changes to. Should be a disposable child context of the main context.
    var context: NSManagedObjectContext!
    
    @IBOutlet var titleTextfield: UITextField!
    

    // MARK: User Interaction

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            
        case "saveList":

            // Create list and set properties
            let list = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context) as! List
            list.title = titleTextfield.text ?? "Unnamed List"
            
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
