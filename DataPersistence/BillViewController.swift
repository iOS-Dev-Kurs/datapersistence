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
            let editContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            editContext.parentContext = context
            editContext.ex
            context.list.purpose = purposeTxt.text ?? "No Name"
            context.list.money = amountTxt.text!
            context.list.date = dateTxt.text ?? "unknown"
        }
    }
}