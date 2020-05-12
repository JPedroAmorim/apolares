//
//  InterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by André Papoti de Oliveira on 08/04/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation
import CoreData
import CloudKit


class InterfaceController: WKInterfaceController {

    // MARK: - Outlets
    @IBOutlet weak var groupRingProgress: WKInterfaceGroup!
    @IBOutlet weak var labelFraction: WKInterfaceLabel!
    @IBOutlet weak var labelRingInstruction: WKInterfaceLabel!
    @IBOutlet weak var labelButtonInstruction: WKInterfaceLabel!
    @IBOutlet weak var buttonStart: WKInterfaceButton!
    @IBOutlet weak var buttonSchedule: WKInterfaceButton!
    
    // MARK: - Variables
    var animationTimer: Timer?
    var stageAnimation = 1
    var firstLaunch: FirstLaunch?
    
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func willActivate() {
        super.willActivate()
        
        let numberOfWashesToday = WashDAO.numberOfWashesToday()
        
        self.firstLaunch = FirstLaunch(userDefaults: .standard, key: "InterfaceController")
        
        self.labelFraction.setText("\(numberOfWashesToday)/5")
        
        self.startAnimationRing(numberOfWashesToday: numberOfWashesToday)
        
        self.animateSequence()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    // MARK: - Methods
    
    private func startAnimationRing(numberOfWashesToday: Int){
        let completionLenght = numberOfWashesToday > 5 ? 100 : numberOfWashesToday * 20
        
        let duration = 1.0
        
        self.groupRingProgress.setBackgroundImageNamed("ring")
        self.groupRingProgress.startAnimatingWithImages(in: NSRange(location: 0, length: completionLenght),
                                                        duration: duration,
                                                        repeatCount: 1)
    }
    
//    private func ringAnimate() {
//        var i: Int = 0
//
//        while i <= 5 {
//
//            self.animationTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (Timer) in
//                self.startAnimationRing(numberOfWashesToday: i)
//
//
//            }
//
//            i += 1
//        }
//
//        Timer.invalidate()
//    }
    
    private func ringInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            self.buttonStart.setAlpha(0.2)
            self.buttonSchedule.setAlpha(0.2)
            self.labelRingInstruction.setHidden(false)
            self.labelRingInstruction.setText("This indicates the progress of the daily goal.")
        })
    }
    
    private func startButtonInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            self.groupRingProgress.setHidden(true)
            self.labelRingInstruction.setHidden(true)
            
            self.buttonSchedule.setAlpha(0.2)
            self.buttonStart.setAlpha(1)
            
            self.labelButtonInstruction.setHidden(false)
            self.labelButtonInstruction.setText("Start button starts the hand wash process.")
        })
    }
    
    private func scheduleButtonInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            self.buttonStart.setAlpha(0.2)
            self.buttonSchedule.setAlpha(1)
            
            self.labelButtonInstruction.setText("Schedule button edit alarm.")
        })
    }
    
    private func finishInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            self.buttonStart.setAlpha(1)
            
            self.groupRingProgress.setHidden(false)
        
            self.labelButtonInstruction.setHidden(true)
        })
    }
    
    private func animateSequence() {
        self.ringInstructionAnimate()
        
        self.animationTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (Timer) in
            
            switch self.stageAnimation {
            case 1:
                self.startButtonInstructionAnimate()
            case 2:
                self.scheduleButtonInstructionAnimate()
            case 3:
                self.finishInstructionAnimate()
            case 4:
                self.stageAnimation = 0
                
                Timer.invalidate()
                
            default:
                Timer.invalidate()
                print("Invalid animate!")
            }

            self.stageAnimation += 1
        }
    }
}
