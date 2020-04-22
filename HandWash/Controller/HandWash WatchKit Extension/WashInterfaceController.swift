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
    
    
    // MARK: - Errors
    enum ProtocolError: Error {
        case invalidVideoUrl(description: String)
        case invalidTextFilePath(description: String)
    }

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
        do {
            let stages = try splitTextInStages(fileName: "HandHygieneProtocol")
            try playEachStage(stages: stages)
            
        } catch ProtocolError.invalidTextFilePath(let description) {
           print(description)
            
        } catch ProtocolError.invalidVideoUrl(let description){
            print(description)
            
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    // TODO: Write this bitch
    private func splitTextInStages(fileName: String) throws -> [String] {
        if let protocolText = Bundle.main.path(forResource: fileName, ofType: "txt") {
            return protocolText.components(separatedBy: "\n")
        } else {
            throw ProtocolError.invalidTextFilePath(description: "Try to see if it is in the copy resources Bundle")
        }
    }
    
    private func playEachStage(stages: [String]) throws {
        var index = 0
        
        for stageText in stages {
            let stageDuration = 0.5
            let delay = DispatchTime.now() + stageDuration
            
            let speechUtterance = AVSpeechUtterance(string: stageText)
            synth.speak(speechUtterance)
            
            let videoFileName = "stage" + String(index)
            if let videoUrl = Bundle.main.url(forResource: videoFileName, withExtension: "mp4") {
                self.inlineMovie.setMovieURL(videoUrl)
            } else {
                throw ProtocolError.invalidVideoUrl(description: "Try to see if it is in the copy resources Bundle")
            }
            self.inlineMovie.setLoops(true)
            self.inlineMovie.play()
            
            index += 1
            
            DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
                self?.inlineMovie.pause()
            }
        }
    }
}

// MARK: - Extensions
   extension AVSpeechSynthesizerDelegate {
       
   }


