//
//  IntentHandler.swift
//  Start Intent Extension
//
//  Created by Felipe Semissatto on 23/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import Intents


class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
       
        guard intent is HandWashIntent else {
             fatalError("Unhandled intent type: \(intent)")
        }
        
        return self
    }
}

