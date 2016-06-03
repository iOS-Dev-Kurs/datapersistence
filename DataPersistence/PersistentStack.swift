//
//  PersistentStack.swift
//  uni-hd
//
//  Created by Nils Fischer on 15.11.15.
//  Copyright © 2015 Universität Heidelberg. All rights reserved.
//

import Foundation
import CoreData


class PersistentStack {
    
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    init(model: NSManagedObjectModel, persistentStoreURL: NSURL) {
        // Setup persistent store coordinator with given model
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            // Add SQLite persistent store at given url
            try persistentStoreCoordinator.addPersistentStoreWithType(
                NSSQLiteStoreType,
                configuration: nil,
                URL: persistentStoreURL,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ]
            )
        } catch {
            fatalError("Failed adding persistent store at URL \(persistentStoreURL): \(error)")
        }
        self.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    /// The context to be used for the user interface on the main thread
    private (set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
}
