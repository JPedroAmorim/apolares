//
//  WashInterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by Felipe Semissatto on 20/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation


class WashInterfaceController: WKInterfaceController {

    // MARK: - Outlets
    @IBOutlet weak var inlineMovie: WKInterfaceInlineMovie!
    @IBOutlet weak var labelDescription: WKInterfaceLabel!
    @IBOutlet weak var imageProgress: WKInterfaceImage!
    
    // MARK: - Constants
    let synth = AVSpeechSynthesizer()
    
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK: - Methods
    
    /**
        
     */
    
   private func playVideos() {
    if let protocolText = Bundle.main.path(forResource: "HandHygieneProtocol", ofType: "txt") {
        // Each stage is separated by a "\n" in the HandHygieneProtocol text file.
        let stages = protocolText.components(separatedBy: "\n")
        
        for stage in stages {
            let speechUtterance = AVSpeechUtterance(string: stage)
            
            // TODO: Play the corresponding video URL in loop through the inlineMovie outlet
            
            synth.speak(speechUtterance)
        }
      }
    }
}

// MARK: - Extensions
   extension AVSpeechSynthesizerDelegate {
       
   }


