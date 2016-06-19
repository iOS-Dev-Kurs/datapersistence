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
    var doubleMaximumWeight: Int!
    var intNumberOfReps: Int!
    
    @IBOutlet var titleTextfield: UITextField!
    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet weak var largeSwitch: UISwitch!
    @IBOutlet weak var maximunLabel: UILabel!
    @IBOutlet weak var maximumSlider: UISlider!
    @IBOutlet weak var numberOfReps: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    // MARK: - User Interaction
    
   

    @IBAction func numerOfRepsValueChange(sender: UISegmentedControl) {
        
        // Get Number of chosen repetition, only activate Save Button if Value has been selected
        
        saveButton.enabled = true
        let index = numberOfReps.selectedSegmentIndex
        var number: Int? {switch index {
        case 0:
            return 5
        case 1:
            return 6
        case 2:
            return 8
        case 3:
            return 10
        case 4:
            return 12
        default:
            return nil
        
            }
        }
        intNumberOfReps = number
        
    }
    
    @IBAction func maximumSliderValueChanged(sender: UISlider) {
        
        doubleMaximumWeight = Int(maximumSlider.value)
        let maxWeight = Float(doubleMaximumWeight)/2
        maximunLabel.text = "Maximum Weight: \(maxWeight)"
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {

        case "saveItem":
            
            // Create item
            let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
            item.list = list
            item.title = titleTextfield.text ?? "Unnamed Item"
            item.large = largeSwitch.on
            item.doubleMaxiumWeight = doubleMaximumWeight
            item.numberOfReps = intNumberOfReps
    
            
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
