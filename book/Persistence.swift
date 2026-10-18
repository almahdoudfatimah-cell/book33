//
//  Persistence.swift
//  book
//
//  Created by Fatimah on 05/11/1447 AH.
//

import Foundation
import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Model") // your .xcdatamodeld name
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }
    }
}
