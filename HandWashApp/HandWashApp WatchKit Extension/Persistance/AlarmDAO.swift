//
//  SemNome.swift
//  HandWash WatchKit Extension
//
//  Created by André Papoti de Oliveira on 14/05/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData

// TODO: Descobrir um nome bom pra essa classe
class AlarmDAO {
    
    static func setDefaultNumberOfIntervals(value: Int16) {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DefaultTimerEntity", in: context)
        
        // Cheking if there is a default value for the timer registered
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DefaultTimerEntity")
        request.predicate = NSPredicate(value: true) // Return all entities of type DefaultTimerEntity
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            if !(result.isEmpty) {
                // Delete current default value to set a new one
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                try CoreDataManager.shared.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            }
            
            // Save new value
            let newDefaultTimerEntry = NSManagedObject(entity: entity!, insertInto: context)
            newDefaultTimerEntry.setValue(value, forKey: "numberOfIntervals")
            
            do {
                try context.save()
                print("Saved")
            }
            catch {
                print("Failed to save new default number of intervals")
            }
            
            
        } catch {
            print("Failed to fetch DefaultTimerEntity")
        }
        
    }
    
    static func getDefaultTimer() -> Int16? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DefaultTimerEntity")
        
        request.predicate = NSPredicate(value: true) // Return the only entity we have
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            if result.isEmpty {
                return nil
            }
            else {
                let data = result[0] as! NSManagedObject
                return data.value(forKey: "numberOfIntervals") as? Int16
            }
            
        }
        catch {
            print("Failed to get default timer")
            return nil
        }
    }
    
    static func saveAlarm(alarmRequest: UNNotificationRequest) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "AlarmEntity", in: context)
        
        // Cheking if there is a default value for the timer registered
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmEntity")
        request.predicate = NSPredicate(value: true) // Return all entities of type DefaultTimerEntity
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            if !(result.isEmpty) {
                // Delete current default value to set a new one
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                try CoreDataManager.shared.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            }
            
            // Save new value
            let newDefaultTimerEntry = NSManagedObject(entity: entity!, insertInto: context)
            newDefaultTimerEntry.setValue(alarmRequest, forKey: "request")
            
            do {
                try context.save()
                print("Saved")
            }
            catch {
                print("Failed to save new date for alarm")
            }
            
            
        } catch {
            print("Failed to fetch AlarmEntity")
        }
    }
    
    static func loadAlarm() -> UNNotificationRequest? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmEntity")
        
        request.predicate = NSPredicate(value: true) // Return the only entity we have
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            if result.isEmpty {
                return nil
            }
            else {
                let data = result[0] as! NSManagedObject
                return data.value(forKey: "request") as? UNNotificationRequest
            }
            
        }
        catch {
            print("Failed to get alarm request")
            return nil
        }
    }
}
