//
//  Schedule.swift
//  HandWash WatchKit Extension
//
//  Created by André Papoti de Oliveira on 27/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import Foundation
import UserNotifications
class Schedule {
    var nextNotification: UNNotificationRequest?
    static let shared = Schedule()
    
    private init() {
        self.nextNotification = nil
    }
    
    func setNotification(notification: UNNotificationRequest, NCenter: UNUserNotificationCenter) {
        if let next = nextNotification {
            NCenter.removePendingNotificationRequests(withIdentifiers: [next.identifier])
        }
        self.nextNotification = notification
    }
    
    func removeNotification(NCenter: UNUserNotificationCenter) {
        if let next = nextNotification {
            NCenter.removePendingNotificationRequests(withIdentifiers: [next.identifier])
        }
        nextNotification = nil
    }
//    func getTime() -> Double? {
//        guard let next = nextNotification else {return nil}
//
//        return 2
//    }
}
