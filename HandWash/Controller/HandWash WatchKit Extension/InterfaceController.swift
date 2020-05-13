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
    @IBOutlet weak var groupButton: WKInterfaceGroup!
    
    @IBOutlet weak var labelFraction: WKInterfaceLabel!
    @IBOutlet weak var labelRingInstruction: WKInterfaceLabel!
    
    @IBOutlet weak var labelButtonInstructionTop: WKInterfaceLabel!
    @IBOutlet weak var labelButtonInstructionBottom: WKInterfaceLabel!
    
    @IBOutlet weak var buttonStart: WKInterfaceButton!
    @IBOutlet weak var buttonSchedule: WKInterfaceButton!
    @IBOutlet weak var buttonSettings: WKInterfaceButton!
    @IBOutlet weak var button: WKInterfaceButton!
    
    // MARK: - Variables
    
    // Variables to tutorial
    var animationTimer: Timer?
    var stageAnimation = 1 // Manages the sequence of tutorial animations
    var firstLaunch: FirstLaunch? // Detect first launch
    
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        let numberOfWashesToday = WashDAO.numberOfWashesToday()
        
        self.labelFraction.setText("\(numberOfWashesToday)/5")
        
        self.startAnimationRing(numberOfWashesToday: numberOfWashesToday)
        
        self.firstLaunch = FirstLaunch(userDefaults: .standard, key: "InterfaceController")
        
        // Check if first launch
        if self.firstLaunch!.isFirstLaunch {
            self.animateSequence()
        } else {
            self.setEnableButtons(isEnable: true)
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK: - Methods
    
    private func startAnimationRing(numberOfWashesToday: Int){
        var completionLength = numberOfWashesToday > 5 ? 100 : numberOfWashesToday * 20
        
        if numberOfWashesToday == 0 {
            completionLength = 1
        }
        
        let duration = 1.0
        
        self.groupRingProgress.setBackgroundImageNamed("ring")
        self.groupRingProgress.startAnimatingWithImages(in: NSRange(location: 0, length: completionLength),
                                                        duration: duration,
                                                        repeatCount: 1)
    }
    
    private func buttonTutorial(enableButton: WKInterfaceButton, instructionLabel: WKInterfaceLabel, textLabel: String) {
        instructionLabel.setText(textLabel)
        self.scroll(to: enableButton, at: .bottom, animated: true)
    }
    
    // Set alpha buttons.
    private func setAlphaButtons(start: CGFloat, schedule: CGFloat, setting: CGFloat, button: CGFloat) {
        self.buttonStart.setAlpha(start)
        self.buttonSchedule.setAlpha(schedule)
        self.buttonSettings.setAlpha(setting)
        self.button.setAlpha(button)
    }
    
    // Set enable buttons.
    private func setEnableButtons(isEnable: Bool) {
        self.buttonStart.setEnabled(isEnable)
        self.buttonSchedule.setEnabled(isEnable)
        self.buttonSettings.setEnabled(isEnable)
        self.button.setEnabled(isEnable)
    }
    
    private func ringAnimate() {
        
        self.groupRingProgress.setBackgroundImageNamed("ring")
        self.animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (Timer) in
 
            self.startAnimationRing(numberOfWashesToday: 5)

            Timer.invalidate()
        }
    }
    
    private func ringInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            
            self.setAlphaButtons(start: 0.2, schedule: 0.2, setting: 0.2, button: 0.2)
            self.labelRingInstruction.setHidden(false)
            self.labelRingInstruction.setText("This indicates the progress of the daily goal.")
        })
    }
    
    private func startButtonInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            self.labelRingInstruction.setHidden(true)
            self.labelButtonInstructionTop.setHidden(false)
            
            self.setAlphaButtons(start: 1.0, schedule: 0.2, setting: 0.2, button: 0.2)
            
            self.buttonTutorial(enableButton: self.buttonStart,
                                instructionLabel: self.labelButtonInstructionTop,
                                textLabel: "Start button starts the hand was process.")
            
            self.groupRingProgress.setAlpha(0.2)
        
        })
    }
    
    private func scheduleButtonInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            
            self.setAlphaButtons(start: 0.2, schedule: 1.0, setting: 0.2, button: 0.2)
            
            self.buttonTutorial(enableButton: self.buttonSchedule,
                                instructionLabel: self.labelButtonInstructionTop,
                                textLabel: "Schedule button edit alarm.")
        })
    }
    
    private func settingButtonInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            
            self.labelButtonInstructionBottom.setHidden(false)
            
            self.setAlphaButtons(start: 0.2, schedule: 0.2, setting: 1.0, button: 0.2)
            
            self.buttonTutorial(enableButton: self.buttonSettings,
                                instructionLabel: self.labelButtonInstructionBottom,
                                textLabel: "Start button starts the hand was process.")
            
            self.labelButtonInstructionTop.setHidden(true)
        })
    }
    
    private func buttonInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            
            self.setAlphaButtons(start: 0.2, schedule: 0.2, setting: 0.2, button: 1.0)
            
            self.buttonTutorial(enableButton: self.button,
                                instructionLabel: self.labelButtonInstructionBottom,
                                textLabel: "Start button starts the hand was process.")
        })
    }
    
    private func finishInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            self.groupRingProgress.setBackgroundImageNamed("ring0")
            self.groupRingProgress.setAlpha(1)
            
            self.setAlphaButtons(start: 1.0, schedule: 1.0, setting: 1.0, button: 1.0)
            self.setEnableButtons(isEnable: true)
            
            self.labelButtonInstructionBottom.setHidden(true)
            
            self.scroll(to: self.groupRingProgress, at: .top, animated: true)
        })
    }
    
    // Organize tutorial actions.
    private func animateSequence() {
        self.ringAnimate()
        self.ringInstructionAnimate()
        
        self.animationTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (Timer) in
                    
        switch self.stageAnimation {
        case 1:
            self.startButtonInstructionAnimate()
        case 2:
            self.scheduleButtonInstructionAnimate()
        case 3:
            self.settingButtonInstructionAnimate()
        case 4:
            self.buttonInstructionAnimate()
        case 5:
            self.finishInstructionAnimate()
        case 6:
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
