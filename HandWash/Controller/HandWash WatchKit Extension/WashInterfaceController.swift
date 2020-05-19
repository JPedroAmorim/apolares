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
    
    @IBOutlet weak var instructionLabelRapticFeedback: WKInterfaceLabel!
    @IBOutlet weak var instructionLabelInLineMovie: WKInterfaceLabel!
    @IBOutlet weak var instructionLabelProgress: WKInterfaceLabel!
    
    @IBOutlet weak var groupProgress: WKInterfaceGroup!
    
    // MARK: - Constants
    let synth = AVSpeechSynthesizer()
    let defaults = UserDefaults.standard
    
    // MARK: - Variables
    var timer: Timer?
    var animationTimer: Timer?
    var firstLaunch: FirstLaunch?
    var stageAnimation = 1
    
    // MARK: - Control variables
    var completion = false
    var shouldAnimate = false
    var shouldPlaySound = false
    var shouldVibrate = false

  
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.firstLaunch = FirstLaunch(userDefaults: .standard, key: "Wash")
        self.completion = false
        
        shouldAnimate = defaults.bool(forKey: "AnimationActive")
        shouldVibrate = defaults.bool(forKey: "VibrationActive")
        shouldPlaySound = defaults.bool(forKey: "SoundActive")
        
        self.groupProgress.setBackgroundImageNamed("Progress")
        handwashProtocol()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        // If it's the first launch and
        // if returned by the back button of the afterWashStoryboard,
        // hiding labels and setting alpha 1. ()
        self.finishInstructionAnimate()
    }
    
    override func willDisappear() {
        super.willDisappear()
        self.groupProgress.stopAnimating()
        self.synth.stopSpeaking(at: .immediate)
        self.timer?.invalidate()
        
        if (completion) {
            WashDAO.createWashEntry()
            completion = false
        }
    }
    
    // MARK: - Methods
    private func handwashProtocol() {
        do {
            let stages = try splitTextInStages(fileName: "HandHygieneProtocol")
            var videoIndex = 0
            let stageDuration = 5.0
            let totalNumberOfStages = stages.count - 2
            
            playEachStage(stageText: stages[videoIndex], videoIndex: videoIndex, stageDuration: stageDuration)
            videoIndex += 1
            
            self.timer = Timer.scheduledTimer(withTimeInterval: stageDuration, repeats: true) { (Timer) in
               
                if self.shouldPlaySound && self.shouldVibrate {
                    WKInterfaceDevice.current().play(.success) // Raptic feedback
                }
                
                if (videoIndex > totalNumberOfStages)  {
                                
                    self.inlineMovie.pause()
                    self.groupProgress.setBackgroundImageNamed("Progress101")
                    
                    Timer.invalidate()
                    
                    self.completion = true
                    
                    DispatchQueue.main.async {
                        self.pushController(withName: "AfterWash", context: self)
                    }
                }
                else if self.firstLaunch!.isFirstLaunch  {
                    self.inlineMovie.pause()
                    self.groupProgress.setBackgroundImageNamed("Progress101")
                    
                    // realizar a animacao para explicar como o app funcina
                    Timer.invalidate()
                    self.animateSequence()
                    
                }
                else {
                    self.playEachStage(stageText: stages[videoIndex], videoIndex: videoIndex, stageDuration: stageDuration)
                    videoIndex += 1
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
        if shouldPlaySound {
            let speechUtterance = AVSpeechUtterance(string: stageText)
            speechUtterance.rate = 0.5
            self.synth.speak(speechUtterance)
        }
       
        if shouldAnimate {
            let videoFileName = "stage" + String(videoIndex)
            if let videoUrl = Bundle.main.url(forResource: videoFileName, withExtension: "mp4", subdirectory: "/videos"){
                self.inlineMovie.setMovieURL(videoUrl)
                self.inlineMovie.play()
            } else {
                print("Invalid video URL! - Try to see if it is in the copy resources Bundle")
            }
            
            self.groupProgress.startAnimatingWithImages(in: NSRange(location: 0, length: 102), duration: stageDuration, repeatCount: 0)
        }
    }
    
    private func rapticFeedbackAnimate() {
        self.instructionLabelRapticFeedback.setText(String("This sound indicates that the stage has ended.").localized)
        self.animate(withDuration: 1, animations: {
            self.inlineMovie.setAlpha(0.2)
            self.groupProgress.setAlpha(0.2)
            self.instructionLabelRapticFeedback.setHidden(false)
        })
    }
    
    private func groupProgressAnimate() {
        
        self.instructionLabelRapticFeedback.setHidden(true)
        self.instructionLabelProgress.setHidden(false)
        
        self.animate(withDuration: 1, animations: {
            self.instructionLabelProgress.setText(String("This bar indicates the progress you've made in this stage.").localized)
            self.groupProgress.setAlpha(1)
        })
    }
    
    private func inlineMovieAnimate() {
        
        self.instructionLabelProgress.setHidden(true)
        self.instructionLabelInLineMovie.setHidden(false)
        
        self.animate(withDuration: 1, animations: {
            self.inlineMovie.setAlpha(1)
            self.groupProgress.setAlpha(0.2)
            
            self.instructionLabelInLineMovie.setText(String("Through this video you'll learn the WHO hand washing protocol.").localized)
        })
    }
    
    private func finishInstructionAnimate() {
        
        self.instructionLabelInLineMovie.setHidden(true)
        self.groupProgress.setAlpha(1)
    }
    
    private func animateSequence() {
        
        self.rapticFeedbackAnimate()
        
        self.animationTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (Timer) in
            
            switch self.stageAnimation {
            case 1:
                self.groupProgressAnimate()
            case 2:
                self.inlineMovieAnimate()
            case 3:
                
                Timer.invalidate()
                
                DispatchQueue.main.async {
                    self.pushController(withName: "AfterWash", context: self)
                }
            default:
                Timer.invalidate()
                print("Invalid animate!")
            }
            
            self.stageAnimation += 1
        }
    }
}

