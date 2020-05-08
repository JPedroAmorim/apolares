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
import CloudKit
import CoreData


class WashInterfaceController: WKInterfaceController {
    
    // MARK: - Errors
    enum ProtocolError: Error {
        case invalidTextFilePath(description: String)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var inlineMovie: WKInterfaceInlineMovie!
    @IBOutlet weak var groupProgress: WKInterfaceGroup!
    
    // MARK: - Constants
    let synth = AVSpeechSynthesizer()
    
    // MARK: - Variables
    var timer: Timer?
    
    // MARK: - Control variables
    var completion = false
         
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.groupProgress.setBackgroundImageNamed("Progress")
        handwashProtocol()
    }
    
    override func willActivate() {
        super.willActivate()
        self.completion = false
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func willDisappear() {
        super.willDisappear()
        self.groupProgress.stopAnimating()
        self.synth.stopSpeaking(at: .immediate)
        self.timer?.invalidate()
        
        if (completion) {
            WashDAO.createWashEntry()
        }
    }
    
    // MARK: - Methods
    

    private func handwashProtocol() {
        do {
            let stages = try splitTextInStages(fileName: "HandHygieneProtocol")
            var videoIndex = 0
            let stageDuration = 0.5
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
                    
                    Timer.invalidate()
                    
                    self.completion = true
                    
                    DispatchQueue.main.async {
                        
                        self.pushController(withName: "AfterWash", context: self)
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
        
        let videoFileName = "stage" + String(videoIndex)
        if let videoUrl = Bundle.main.url(forResource: videoFileName, withExtension: "mp4", subdirectory: "/videos"){
            self.inlineMovie.setMovieURL(videoUrl)
            self.inlineMovie.play()
        } else {
            print("Invalid video URL! - Try to see if it is in the copy resources Bundle")
        }
        
         self.groupProgress.startAnimatingWithImages(in: NSRange(location: 0, length: 102), duration: stageDuration, repeatCount: 0)
    }

//    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
//
//    }
}

