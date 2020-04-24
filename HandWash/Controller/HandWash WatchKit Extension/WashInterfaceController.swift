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
    
    var timer: Timer?
         
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.groupProgress.setBackgroundImageNamed("Progress")
        handwashProtocol()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func willDisappear() {
        super.willDisappear()
        self.synth.stopSpeaking(at: .immediate)
        self.timer?.invalidate()
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
            
            self.timer = Timer.scheduledTimer(withTimeInterval: stageDuration, repeats: true) { (Timer) in
                WKInterfaceDevice.current().play(.success) // Raptic feedback
                
               self.playEachStage(stageText: stages[videoIndex], videoIndex: videoIndex, stageDuration: stageDuration)
                videoIndex += 1
                
                if videoIndex > totalNumberOfStages {
                    self.inlineMovie.pause()
                    self.groupProgress.setBackgroundImageNamed("Progress101")
                    self.labelDescription.setText("Done!")
                    
                    Timer.invalidate()
                    
                    DispatchQueue.main.async {
                        self.pushController(withName: "AfterWash", context: nil)
                    }
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
        
        let videoFileName = "stage" + String(videoIndex)
        if let videoUrl = Bundle.main.url(forResource: videoFileName, withExtension: "mp4", subdirectory: "/videos"){
            self.inlineMovie.setMovieURL(videoUrl)
            self.inlineMovie.play()
        } else {
            print("Invalid video URL! - Try to see if it is in the copy resources Bundle")
        }
        
        doAnimation(duration: stageDuration)
    }
    
    private func doAnimation(duration: Double) {
        self.groupProgress.startAnimatingWithImages(in: NSRange(location: 0, length: 102), duration: duration, repeatCount: 1)
    }
}

// MARK: - Extensions
extension AVSpeechSynthesizerDelegate {
    
}


