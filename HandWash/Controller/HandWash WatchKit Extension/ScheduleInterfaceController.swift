//
//  ScheduleInterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by Rodrigo Takumi on 22/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class ScheduleInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var timer: WKInterfaceTimer!
    
    @IBAction func scheduleAction() {
        sendMyNotification()
    
    }
    
    func sendMyNotification(){
        if #available(watchOSApplicationExtension 3.0, *) {

            let center = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }


            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "REMINDER_CATEGORY"
            // Deliver the notification in five seconds.
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
            let id = String(Date().timeIntervalSinceReferenceDate)
            let request = UNNotificationRequest.init(identifier: id, content: content, trigger: trigger)

            // Schedule the notification.

            center.add(request ,withCompletionHandler: nil)

        } else {
            // Fallback on earlier versions
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
