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
    var context : NSManagedObjectContext!
    var overviewBill : Overview!
    
    @IBOutlet weak var purposeTxt: UITextField!
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addBill" {
            let list = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context) as! List
            list.list = overviewBill
            list.purpose = purposeTxt.text ?? "No Name"
            list.money = Double(amountTxt.text!)!
            list.date = dateTxt.text ?? "unknown"
        }
    }
}