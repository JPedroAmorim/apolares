//
//  InterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by André Papoti de Oliveira on 08/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation
import Intents


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setActivity()
        
        // Configure interface objects here.
    }
    
    func setActivity() {
        let userActivity = NSUserActivity(activityType: "Start_Wash")
        
        userActivity.title = "Start Wash"
        userActivity.suggestedInvocationPhrase = "Start Wash"
        userActivity.isEligibleForPrediction = true
        
        let shortcut = INShortcut(userActivity: userActivity)
        let relevantShortcut = INRelevantShortcut(shortcut: shortcut)

        INRelevantShortcutStore.default.setRelevantShortcuts([relevantShortcut], completionHandler: { error in
            INRelevantShortcut.description()
            if let error = error {
                print("AAAAAAAAA \(error)")
            }
        })
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
