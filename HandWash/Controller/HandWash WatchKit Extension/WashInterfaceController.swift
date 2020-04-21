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
    
   private func handwashProtocol() {
    if let protocolText = Bundle.main.path(forResource: "HandHygieneProtocol", ofType: "txt") {
        // Each stage is separated by a "\n" in the HandHygieneProtocol text file.
        let stages = protocolText.components(separatedBy: "\n")
        
        for stage in stages {
            
            // TODO: MAKE A PRIVATE METHOD OUT OF THIS!!
            
            let speechUtterance = AVSpeechUtterance(string: stage)
            // TODO: Play the corresponding video URL in loop through the inlineMovie outlet
            
            // Defining each stage time period
            let stageDuration = 0.5
            let delay = DispatchTime.now() + stageDuration
            
            synth.speak(speechUtterance)
            
            // TODO: Think about the delay time and the fact it's in a for each stage... how should it be handled?
            DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
               
                // inlineMovie.stop() - Maybe?
            }
          }
       }
    }
    
    // TODO: Write this bitch
    private playStageAndLoopVideo(){}
}

// MARK: - Extensions
   extension AVSpeechSynthesizerDelegate {
       
   }


