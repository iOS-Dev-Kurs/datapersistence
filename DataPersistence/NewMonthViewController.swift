//
//  createNewMonth.swift
//  DataPersistence
//
//  Created by Christoph Blattgerste on 08.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewMonthViewController : UIViewController {
    var context : NSManagedObjectContext!
    
    @IBOutlet weak var newMonthTxt: UITextField!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveNewMonth" {
            let overview = NSEntityDescription.insertNewObjectForEntityForName("Overview", inManagedObjectContext: context) as! Overview
            overview.newMonth = newMonthTxt.text ?? "Unnamed Month"
        }
    
    }
}
