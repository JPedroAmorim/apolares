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
    @IBOutlet weak var labelRingInstruction: WKInterfaceLabel!
    @IBOutlet weak var labelStartInstruction: WKInterfaceLabel!
    @IBOutlet weak var labelScheduleInstruction: WKInterfaceLabel!
    @IBOutlet weak var labelBottomButtonInstruction: WKInterfaceLabel!
    @IBOutlet weak var buttonStart: WKInterfaceButton!
    @IBOutlet weak var buttonSchedule: WKInterfaceButton!
    @IBOutlet weak var buttonSettings: WKInterfaceButton!
    @IBOutlet weak var button: WKInterfaceButton!
    @IBOutlet weak var groupHandWashAnimation: WKInterfaceGroup!
    
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
        
//        self.labelFraction.setText("\(numberOfWashesToday)/5")
        
        self.startAnimationRing(numberOfWashesToday: numberOfWashesToday)
        self.startAnimationHandWash(numberOfWashesToday: numberOfWashesToday)
        
        self.firstLaunch = FirstLaunch(userDefaults: .standard, key: "InterfaceController")
        
        let dict = WashDAO.allWashesEntries()
        
        let sortedKeys = Array(dict.keys).sorted(by: >)
        
        print("DIIICT \(sortedKeys)")
        
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
    
    private func startAnimationHandWash(numberOfWashesToday: Int){
        var completionLength = 21
        
        if numberOfWashesToday == 0 {
            completionLength = 1
        }
        
        let duration = 1.0
        
        self.groupHandWashAnimation.setBackgroundImageNamed("HandWash")
        self.groupHandWashAnimation.startAnimatingWithImages(in: NSRange(location: 0, length: completionLength),
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
            self.labelRingInstruction.setText(String("This ring indicates the progress of your daily hand washing goal.").localized)
        })
    }
    
    private func startButtonInstructionAnimate() {
        
        self.labelRingInstruction.setHidden(true)
        self.labelStartInstruction.setHidden(false)
        
        self.animate(withDuration: 1, animations: {
            
            self.labelStartInstruction.setText(String("This button will start the hand washing protocol.").localized)
            
            self.setAlphaButtons(start: 1.0, schedule: 0.2, setting: 0.2, button: 0.2)
            self.scroll(to: self.labelStartInstruction, at: .top, animated: true)
            
            self.groupRingProgress.setAlpha(0.2)
        
        })
    }
    
    private func scheduleButtonInstructionAnimate() {
        
        self.labelStartInstruction.setHidden(true)
        self.labelScheduleInstruction.setHidden(false)
        
        self.labelScheduleInstruction.setText(String("Through the schedule button you'll be able to alter the existing notification alarm or disable it, as well as add an alarm if there isn't a current one.").localized)
        
        self.animate(withDuration: 1, animations: {
            
            self.setAlphaButtons(start: 0.2, schedule: 1.0, setting: 0.2, button: 0.2)
            self.scroll(to: self.labelScheduleInstruction, at: .top, animated: true)
        })
    }
    
    private func settingButtonInstructionAnimate() {
        
        self.labelScheduleInstruction.setHidden(true)
        self.labelBottomButtonInstruction.setHidden(false)
        
        self.labelBottomButtonInstruction.setText(String("The Settings button allows you to change the app's configuration.").localized)
        
        self.animate(withDuration: 1, animations: {
            
            self.setAlphaButtons(start: 0.2, schedule: 0.2, setting: 1.0, button: 0.2)
            
            self.scroll(to: self.labelBottomButtonInstruction, at: .top, animated: true)
        })
    }
    
    private func buttonInstructionAnimate() {
        
        self.animate(withDuration: 1, animations: {
            
            self.labelBottomButtonInstruction.setText(String("Through the history button you'll see your consistency in reaching your daily hand washing goal.").localized)
            
            self.setAlphaButtons(start: 0.2, schedule: 0.2, setting: 0.2, button: 1.0)
        })
    }
    
    private func finishInstructionAnimate() {
        self.animate(withDuration: 1, animations: {
            self.groupRingProgress.setBackgroundImageNamed("ring0")
            self.groupRingProgress.setAlpha(1)
            
            self.setAlphaButtons(start: 1.0, schedule: 1.0, setting: 1.0, button: 1.0)
            self.setEnableButtons(isEnable: true)
            
            self.labelBottomButtonInstruction.setHidden(true)
            
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
                
            Timer.invalidate()
            default:
                Timer.invalidate()
                print("Invalid animate!")
            }
            self.stageAnimation += 1
        }
    }
}
