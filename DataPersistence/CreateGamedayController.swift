//
//  NewGameday.swift
//  DataPersistence
//
//  Created by Colin Otchere on 11.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewGamedayController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    var context: NSManagedObjectContext!
    var selection: String = ""
    
    @IBOutlet weak var numberPicker: UIPickerView!
    
    let pickerData = ["Gruppenphase 1. Spieltag","Gruppenphase 2. Spieltag","Gruppenphase 3. Spieltag","Achtelfinale","Viertelfinal","Halbfinale","Final"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberPicker.dataSource = self
        numberPicker.delegate = self
    }

    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selection = pickerData[row]
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
                        
        case "saveGameday":
            
            // Create list and set properties
            let list = NSEntityDescription.insertNewObjectForEntityForName("Gameday", inManagedObjectContext: context) as! Gameday
            list.title = selection ?? "Unnamed List"
            
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