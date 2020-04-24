//
//  HandWashIntentHandler.swift
//  Start Intent Extension
//
//  Created by Felipe Semissatto on 24/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import Foundation

class HandWashIntentHandler: NSObject, HandWashIntentHandling{
    func handle(intent: HandWashIntent, completion: @escaping (HandWashIntentResponse) -> Void) {
        let activity = NSUserActivity(activityType: "HandWashIntent")
        let title = "Hand Wash"
        activity.title = title
//        activity.userInfo = ["id": board.identifier]
        activity.suggestedInvocationPhrase = title
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = title
        
        let response = HandWashIntentResponse(code: .continueInApp,
                                              userActivity: activity)
        
        completion(response)
    }
}
