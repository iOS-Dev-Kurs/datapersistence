//
//  BillViewController.swift
//  DataPersistence
//
//  Created by Christoph Blattgerste on 07.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BillViewController: UIViewController {
//    new content is saved in:
    var context : NSManagedObjectContext!
//    write new bill to:
    var overviewBill : Overview!
    
    @IBOutlet weak var purposeTxt: UITextField!
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addBill" {
//            new bill will be created:
            let list = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context) as! List
            
//            information is given to:
            
//            list.list = overviewBill
            list.purpose = purposeTxt.text ?? "No Name"
            list.money = amountTxt.text!
            list.date = dateTxt.text ?? "unknown"
            
//            content has to be saved every single time
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }
        }
    }
}