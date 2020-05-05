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
    // MARK: - Outlets
    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var UpperButton: WKInterfaceButton!
    @IBOutlet weak var BottomButton: WKInterfaceButton!
    
    @IBAction func scheduleAction() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { settings in
            //print(settings)
            if settings.authorizationStatus == .notDetermined {
                // Ask for user permissions
                // ### nao tenho certeza sobre as autorizacoes necessarias ainda
                center.requestAuthorization(options: [.alert, .sound, .badge],
                                            completionHandler: { granted, error in
                                                if let error = error {
                                                    print(error)
                                                }
                                                else if granted {
                                                    self.createNotification(NCenter: center)
                                                }
                                                
                })
            }
            else if settings.authorizationStatus == .denied {
                // Alert the user to change permission
                // ### Nao sei se devo mandar o usuario pros settings
                center.requestAuthorization(options: [.alert, .sound, .badge],
                                            completionHandler: { granted, error in
                                                if let error = error {
                                                    print(error)
                                                }
                                                else if granted {
                                                    self.createNotification(NCenter: center)
                                                }
                })
            }
            else { // permission is provisional or authorized
                // Schedule a notification
                self.createNotification(NCenter: center)
            }
        })
    }
    @IBAction func bottomButtonAction() {
        let center = UNUserNotificationCenter.current()
        Schedule.shared.removeNotification(NCenter: center)
        self.pop()
    }
    
    // MARK: - Variables
    var crownAcumulator: Double = 0
    var numberOfTimeIntervals: Int = 0 // Each interval is equivalent to 15 minutes
    
    // MARK: - Lifecycle
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        setTitle("Set alarm")
        // Crown setup
        crownSequencer.delegate = self
        crownSequencer.focus()
        // Timer setup
        let date = Date(timeIntervalSinceNow: 2 * 60 * 60 + 1) // 2 hours and 1 sec
        numberOfTimeIntervals = 8 // Sync this variable with the time suggested
        timer.setDate(date) // Timer suggestion
        // Label and button setup
        if let _ = Schedule.shared.nextNotification {
            UpperButton.setTitle("Reeschedule")
            BottomButton.setTitle("Turn off alarm")
        }
        else {
            UpperButton.setTitle("Set alarm")
            BottomButton.setTitle("Don't remind me")

        }
    }

    // MARK: - Methods
    func createNotification(NCenter: UNUserNotificationCenter) {
        var components = DateComponents()
        let date = Date()
        let timerHours: Int = self.numberOfTimeIntervals / 4
        let timerMinutes: Int = (self.numberOfTimeIntervals % 4) * 15
        let calendar = Calendar.current
        components.calendar = calendar
        components.hour = timerHours + calendar.component(.hour, from: date)
        components.minute = timerMinutes + calendar.component(.minute, from: date)
        // Have to fix these ! later ..
        if components.minute! > 60 {
            components.minute! -= 60
            components.hour! += 1
        }
        if let hour = components.hour, let minutes = components.minute {
            print("Alarm scheduled to \(hour):\(minutes)")
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components,
                                                    repeats: false)
        // let testTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "myNotification"
        content.title = "HandWash"
        content.body = "Wash hands plz"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "Test notification",
                                            content: content,
                                            trigger: trigger)
        NCenter.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print(error ?? "nao sei")
            }
            else {
                print("notification scheduled")
                Schedule.shared.setNotification(notification: request,
                                                NCenter: NCenter)
                self.pop()
            }
        })
    }
}

// MARK: - WKCrownDelegate
extension ScheduleInterfaceController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        crownAcumulator += rotationalDelta
        if crownAcumulator > 1 {
            if numberOfTimeIntervals < 96  {
                numberOfTimeIntervals += 1
                let seconds = numberOfTimeIntervals * 60 * 15 + 1
                let date: Date = Date(timeIntervalSinceNow: TimeInterval(seconds))
                timer.setDate(date)
            }
            crownAcumulator -= 1
        }
        else if crownAcumulator < -1 {
            if numberOfTimeIntervals > 0 {
                numberOfTimeIntervals -= 1
                let seconds = numberOfTimeIntervals * 60 * 15 + 1
                let date: Date = Date(timeIntervalSinceNow: TimeInterval(seconds))
                timer.setDate(date)
            }
            crownAcumulator += 1
        }
    }
}
