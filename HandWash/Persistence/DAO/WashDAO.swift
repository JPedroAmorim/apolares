//
//  DAO.swift
//  HandWash WatchKit Extension
//
//  Created by João Pedro de Amorim on 08/05/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import Foundation
import CoreData


class WashDAO {
    
    static func createWashEntry() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "WashEntity", in: context)
        
        let newWashEntry = NSManagedObject(entity: entity!, insertInto: context)
        
        let todaysDate = createFormattedDateAsString(currentDate: Date())
        
        newWashEntry.setValue(todaysDate, forKey: "date")
        
        do {
            try context.save()
            print("Entity saved!")
        } catch {
            print("Failed saving")
        }
    }
    
    static func deleteAllWashEntries() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WashEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataManager.shared.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            print("Deleted all entries!")
        } catch let error as NSError {
            print("Error!  - \(error)")
        }
    }
    
    static func deleteAllPastWashEntries() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WashEntity")
        
        let todaysDate = createFormattedDateAsString(currentDate: Date())
        
        fetchRequest.predicate = NSPredicate(format: "date < %@", todaysDate)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataManager.shared.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            print("Deleted all entries from previous dates in the Database!")
        } catch let error as NSError {
            print("Error!  - \(error)")
        }
        
    }
    
    static func numberOfWashesToday() -> Int {
        var numberOfWashes = 0
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WashEntity")
        
        let todaysDate = createFormattedDateAsString(currentDate: Date())
        
        request.predicate = NSPredicate(format: "date == %@", todaysDate)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                numberOfWashes += 1
                print(data.value(forKey: "date") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
        
        return numberOfWashes
    }
    
    static func createFormattedDateAsString(currentDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: currentDate)
    }
}
