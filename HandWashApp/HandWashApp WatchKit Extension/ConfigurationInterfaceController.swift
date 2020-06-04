//
//  ConfigutationInterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by João Pedro de Amorim on 12/05/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation


class ConfigutationInterfaceController: WKInterfaceController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var soundSwitch: WKInterfaceSwitch!
    
    @IBOutlet weak var vibrationSwitch: WKInterfaceSwitch!
    
    @IBOutlet weak var animationSwitch: WKInterfaceSwitch!
    
    @IBOutlet weak var picker: WKInterfacePicker!
    
    let defaults = UserDefaults.standard
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        setAllSwitches()
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func soundChanged(_ value: Bool) {
        defaults.set(value, forKey: "SoundActive")
    }
    
    @IBAction func vibrationChanged(_ value: Bool) {
        defaults.set(value, forKey: "VibrationActive")
    }
    
    @IBAction func animationChanged(_ value: Bool) {
        defaults.set(value, forKey: "AnimationActive")
    }
    
    private func setAllSwitches() {
        soundSwitch.setOn(defaults.bool(forKey: "SoundActive"))
        vibrationSwitch.setOn(defaults.bool(forKey: "VibrationActive"))
        animationSwitch.setOn(defaults.bool(forKey: "AnimationActive"))
    }

}
