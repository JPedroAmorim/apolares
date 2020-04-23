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
        case invalidTextFilePath(description: String)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var inlineMovie: WKInterfaceInlineMovie!
    @IBOutlet weak var labelDescription: WKInterfaceLabel!
    @IBOutlet weak var groupProgress: WKInterfaceGroup!
    
    // MARK: - Constants
    let synth = AVSpeechSynthesizer()
    
    // MARK: - Variables
    var delay = DispatchTime.now()
    
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
            var videoIndex = 0
            let stageDuration = 6.0
            let totalNumberOfStages = stages.count - 1
            
            playEachStage(stageText: stages[videoIndex], videoIndex: videoIndex, stageDuration: stageDuration)
            videoIndex += 1
            
            Timer.scheduledTimer(withTimeInterval: stageDuration, repeats: true) { (Timer) in
                DispatchQueue.main.async {
                   self.playEachStage(stageText: stages[videoIndex], videoIndex: videoIndex, stageDuration: stageDuration)
                    videoIndex += 1
                }
                
                if videoIndex >= (totalNumberOfStages - 1) {
                    Timer.invalidate()
                    self.inlineMovie.pause()
                }
            }
            
        } catch ProtocolError.invalidTextFilePath(let description) {
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
    
    private func playEachStage(stageText: String, videoIndex: Int, stageDuration: Double){
        let speechUtterance = AVSpeechUtterance(string: stageText)
        speechUtterance.rate = 0.5
        self.synth.speak(speechUtterance)
        
        self.labelDescription.setText(stageText)
        
        doAnimation(duration: stageDuration)
        
        let videoFileName = "stage" + String(videoIndex)
        if let videoUrl = Bundle.main.url(forResource: videoFileName, withExtension: "mp4", subdirectory: "/videos"){
            self.inlineMovie.setMovieURL(videoUrl)
            self.inlineMovie.play()
        } else {
            print("Invalid video URL! - Try to see if it is in the copy resources Bundle")
        }
    }
    
    private func doAnimation(duration: Double) {
        self.groupProgress.setBackgroundImageNamed("Progress")
        
        self.groupProgress.startAnimatingWithImages(in: NSRange(location: 0, length: 102), duration: duration, repeatCount: 0)
    }
}

// MARK: - Extensions
extension AVSpeechSynthesizerDelegate {
    
}


