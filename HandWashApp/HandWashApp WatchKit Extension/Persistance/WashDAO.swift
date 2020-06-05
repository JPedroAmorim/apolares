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
    
    static func mockWashEntry() {

        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "WashEntity", in: context)

        let firstWashEntry = NSManagedObject(entity: entity!, insertInto: context)
        
        let secondWashEntry = NSManagedObject(entity: entity!, insertInto: context)
        
        let thirdWashEntry = NSManagedObject(entity: entity!, insertInto: context)
        
        firstWashEntry.setValue("5/28/20", forKey: "date")
        firstWashEntry.setValue(2, forKey: "washes")
        
        secondWashEntry.setValue("5/29/20", forKey: "date")
        secondWashEntry.setValue(4, forKey: "washes")
        
        thirdWashEntry.setValue("6/4/20", forKey: "date")
        thirdWashEntry.setValue(3, forKey: "washes")
        
        do {
            try context.save()
        } catch {
            print("Failed saving mocks")
        }

    }
    
    static func createWashEntry() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WashEntity")
        
        let todaysDate = DateUtil.shared.formatter.string(from: Date())
        
        fetchRequest.predicate = NSPredicate(format: "date == %@", todaysDate)
    
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count == 0 {
                let entity = NSEntityDescription.entity(forEntityName: "WashEntity", in: context)
                
                let newWashEntry = NSManagedObject(entity: entity!, insertInto: context)
                
                newWashEntry.setValue(todaysDate, forKey: "date")
                newWashEntry.setValue(1, forKey: "washes")
            } else {
                let washEntryUpdate = result[0] as! NSManagedObject
                
                let previousWashes = washEntryUpdate.value(forKey: "washes") as! Int16
                let updateWashes = previousWashes + 1
                
                washEntryUpdate.setValue(updateWashes, forKey: "washes")
            }
            
            try context.save()
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
        
        let todaysDate = DateUtil.shared.formatter.string(from: Date())
        
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
        var numberOfWashes = Int16(0)
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WashEntity")
        
        let todaysDate = DateUtil.shared.formatter.string(from: Date())
        
        request.predicate = NSPredicate(format: "date == %@", todaysDate)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if result.count > 0 {
                let washEntry = result[0] as! NSManagedObject
                
                numberOfWashes = washEntry.value(forKey: "washes") as! Int16
            }
            
        } catch {
            print("Failed")
        }
        
        return Int(numberOfWashes)
    }
    
    
    static func allWashesEntries() -> [String : Int] {
        var resultDict: [String : Int] = [:]
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WashEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            for washEntry in result as! [NSManagedObject] {
                let numberOfWashesFromEntry = washEntry.value(forKey: "washes") as! Int16
                let dateFromEntry = washEntry.value(forKey: "date") as! String
                
                resultDict.updateValue(Int(numberOfWashesFromEntry), forKey: dateFromEntry)
            }
            
        } catch {
            print("Error")
        }
    
        return resultDict
    }
}

