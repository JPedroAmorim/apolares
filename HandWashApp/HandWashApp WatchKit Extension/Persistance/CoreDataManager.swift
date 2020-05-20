//
//  CoreDataManager.swift
//  HandWash WatchKit Extension
//
//  Created by João Pedro de Amorim on 07/05/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

class CoreDataManager {
    private init() {}
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "WashModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                fatalError("Error: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
