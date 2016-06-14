//
//  AppDelegate.swift
//  DataPersistence
//
//  Created by Nils Fischer on 03.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let persistentStack: PersistentStack = {
        let modelURL = NSBundle.mainBundle().URLForResource("DataPersistence", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOfURL: modelURL)!
        let storeURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("UserData.sqlite")
        return PersistentStack(model: model, persistentStoreURL: storeURL)
    }()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // The context is our connection to Core Data's managed objects.
        
        let listsVC = (window!.rootViewController as! UINavigationController).topViewController as! OverviewViewController
        listsVC.context = persistentStack.mainContext
        
        return true
    }

}

