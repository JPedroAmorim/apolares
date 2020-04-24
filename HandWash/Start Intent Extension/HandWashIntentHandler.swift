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
        let response = HandWashIntentResponse(code: .continueInApp,
                                              userActivity: nil)
        completion(response)
    }
}
