//
//  WashInterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by Felipe Semissatto on 20/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation


class WashInterfaceController: WKInterfaceController {

    //MARK: - Outlets
    @IBOutlet weak var inlineMovie: WKInterfaceInlineMovie!
    @IBOutlet weak var labelDescription: WKInterfaceLabel!
    @IBOutlet weak var imageProgress: WKInterfaceImage!
    
    var userActivity: NSUserActivity?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        userActivity = NSUserActivity(activityType: "HandWashIntent")
        let title = "Hand Wash"
        userActivity?.title = title
//        activity.userInfo = ["id": board.identifier]
        userActivity?.isEligibleForPrediction = true
        userActivity?.isEligibleForSearch = true
        userActivity?.suggestedInvocationPhrase = "Washing hands"
        userActivity?.isEligibleForPrediction = true
        userActivity?.persistentIdentifier = title
        userActivity?.becomeCurrent()
        update(userActivity!)
        
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
