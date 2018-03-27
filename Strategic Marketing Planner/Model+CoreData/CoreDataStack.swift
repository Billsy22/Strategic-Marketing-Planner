//
//  CoreDataStack.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Strategic_Marketing_Planner")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Failed to load from persistent store: \(error.localizedDescription), \(error.userInfo)")
            }
        })
        return container
    }()
    static let context = CoreDataStack.container.viewContext
}
