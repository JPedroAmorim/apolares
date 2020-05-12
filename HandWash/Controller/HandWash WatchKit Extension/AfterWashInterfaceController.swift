//
//  AfterWashInterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by André Papoti de Oliveira on 22/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class AfterWashInterfaceController: WKInterfaceController {

    // MARK: - Outlets
    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var buttonSetAlarm: WKInterfaceButton!
    @IBOutlet weak var buttonDontRemindMe: WKInterfaceButton!
    
    // Outlets to tutorial
    @IBOutlet weak var groupSetAlarm: WKInterfaceGroup!
    @IBOutlet weak var labelInstructionDontRemindMe: WKInterfaceLabel!
    @IBOutlet weak var groupSetAlarmTimer: WKInterfaceGroup!
    
    @IBOutlet weak var groupDontRemindMe: WKInterfaceGroup!
    @IBOutlet weak var labelInstructionSetAlarm: WKInterfaceLabel!
    
    // MARK: - Variables
    var crownAcumulator: Double = 0
    var numberOfTimeIntervals: Int = 0 // Each interval is equivalent to 15 minutes
    
    // Variables to tutorial
    var animationTimer: Timer?
    var firstLaunch: FirstLaunch?
    var stageAnimation = 1
    
    // MARK: - IBAction
    @IBAction func setAlarm() {
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
    @IBAction func dontRemindMeAction() {
        let center = UNUserNotificationCenter.current()
        Schedule.shared.removeNotification(NCenter: center)
        self.popToRootController()
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
                
                self.popToRootController()
            }

        })
    }
    
    private func animateSequence() {
        self.setAlarmInstructionAnimate()
        
        self.animationTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (Timer) in
            
            switch self.stageAnimation {
            case 1:
                self.setAlarmInstructionAnimateCrown()
            case 2:
                self.setAlarmInstructionAnimateButton()
            case 3:
                self.dontRemindMeInstructionAnimate()
            case 4:
                self.stageAnimation = 0 // Não precisa disso se tiver o userdefauls verificando a primeira vez
                
                Timer.invalidate()
                
                DispatchQueue.main.async {
                    self.popToRootController()
                    self.pushController(withName: "InterfaceController.", context: self)
                }
            default:
                Timer.invalidate()
                print("Invalid animate!")
            }
            
            self.stageAnimation += 1
        }
    }
    
    private func setAlarmInstructionAnimate() {
        self.labelInstructionDontRemindMe.setHidden(true)
        self.labelInstructionSetAlarm.setHidden(false)
        self.labelInstructionSetAlarm.setText("You can be notified to wash your hands.")
        
        self.animate(withDuration: 1, animations: {
            self.groupSetAlarm.setAlpha(1)
            self.buttonDontRemindMe.setAlpha(0.2)
        })
    }
    
    private func setAlarmInstructionAnimateCrown() {
        self.labelInstructionDontRemindMe.setHidden(true)
        self.labelInstructionSetAlarm.setHidden(false)
        self.labelInstructionSetAlarm.setText("You can change the timer by the crown...")
        
        self.animate(withDuration: 2, animations: {
            self.groupSetAlarm.setAlpha(1)
            self.buttonDontRemindMe.setAlpha(0.2)
            self.buttonSetAlarm.setAlpha(0.2)
            
            self.groupSetAlarmTimer.setBackgroundColor(UIColor.white)
        })
        
        self.animate(withDuration: 2, animations: {
            self.groupSetAlarmTimer.setBackgroundColor(UIColor.black)
        })
    }
    
    private func setAlarmInstructionAnimateButton() {
        self.labelInstructionDontRemindMe.setHidden(true)
        self.labelInstructionSetAlarm.setHidden(false)
        self.labelInstructionSetAlarm.setText("...and set the alarm to be reminded.")
        
        self.animate(withDuration: 1, animations: {
            self.groupSetAlarm.setAlpha(1)
            self.buttonDontRemindMe.setAlpha(0.2)
            self.buttonSetAlarm.setAlpha(1)
            self.groupSetAlarmTimer.setAlpha(0.2)
        })
    }
    
    private func dontRemindMeInstructionAnimate() {
        self.labelInstructionSetAlarm.setHidden(true)
        self.labelInstructionDontRemindMe.setHidden(false)
        self.labelInstructionDontRemindMe.setText("Or you can choose to be not reminded to wash your hands.")
        
        self.animate(withDuration: 1, animations: {
            self.buttonDontRemindMe.setAlpha(1)
            self.groupDontRemindMe.setAlpha(1)
            self.groupSetAlarm.setAlpha(0.2)
        })
    }
    
    
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }

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
        
        self.firstLaunch = FirstLaunch(userDefaults: .standard, key: "AfterWash")
        
        if self.firstLaunch!.isFirstLaunch {
            self.animateSequence()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

extension AfterWashInterfaceController: WKCrownDelegate {
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
