//
//  InterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by André Papoti de Oliveira on 08/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation
import CoreData
import CloudKit


class InterfaceController: WKInterfaceController {

    // MARK: - Outlets
    @IBOutlet weak var groupRingProgress: WKInterfaceGroup!
    @IBOutlet weak var labelFraction: WKInterfaceLabel!
   
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    
    override func willActivate() {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WashEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
//        do {
//            try CoreDataManager.shared.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
//            print("Deleted!")
//        } catch let error as NSError {
//            print("Error!")
//        }

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WashEntity")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
               print(data.value(forKey: "date") as! String)
          }
            
        } catch {
            print("Failed")
        }
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.startAnimationRing(completionLenght: 60)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    // MARK: - Methods
    
    private func startAnimationRing(completionLenght: Int){
        let duration = 2.0
        
        self.groupRingProgress.setBackgroundImageNamed("ring")
        self.groupRingProgress.startAnimatingWithImages(in: NSRange(location: 0, length: completionLenght),
                                                        duration: duration,
                                                        repeatCount: 1)

    }
}
