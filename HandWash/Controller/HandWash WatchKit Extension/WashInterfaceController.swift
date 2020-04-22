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
    let stageDuration = 10.0
    
    // MARK: - Variables
    var delay = DispatchTime.now()
    var videoIndex = 0
    
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        handwashProtocol()
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
            
            try playEachStage(stageText: stages[videoIndex])
            
            videoIndex += 1
            
            Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { (Timer) in
                DispatchQueue.main.async {
                   self.playEachStage(stageText: stages[self.videoIndex])
                    self.videoIndex += 1
                }
                
                if self.videoIndex >= 15 {
                    Timer.invalidate()
                }
            }
            
        } catch ProtocolError.invalidTextFilePath(let description) {
            print(description)
            
        } catch ProtocolError.invalidVideoUrl(let description){
            print(description)
            
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    private func splitTextInStages(fileName: String) throws -> [String] {
        if let protocolPath = Bundle.main.path(forResource: fileName, ofType: "txt") {
            let protocolText = try String(contentsOfFile: protocolPath, encoding: String.Encoding.utf8)
            return protocolText.components(separatedBy: "\n")
        } else {
            throw ProtocolError.invalidTextFilePath(description: "Invalid file path! - Try to see if it is in the copy resources Bundle")
        }
    }
    
    private func playEachStage(stageText: String){
        let speechUtterance = AVSpeechUtterance(string: stageText)
        speechUtterance.rate = 0.5
        self.synth.speak(speechUtterance)
        
        self.labelDescription.setText(stageText)
        
        let videoFileName = "stage" + String(self.videoIndex)
        if let videoUrl = Bundle.main.url(forResource: videoFileName, withExtension: "mp4", subdirectory: "/videos"){
            self.inlineMovie.setMovieURL(videoUrl)
            self.inlineMovie.play()
            self.inlineMovie.setLoops(true)
        } else {
            // throw ProtocolError.invalidVideoUrl(description: "Invalid video URL! - Try to see if it is in the copy resources Bundle")
        }
    }
}

// MARK: - Extensions
extension AVSpeechSynthesizerDelegate {
    
}


