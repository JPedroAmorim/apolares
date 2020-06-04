//
//  DailyInterface.swift
//  HandWashApp WatchKit Extension
//
//  Created by André Papoti de Oliveira on 04/06/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import Foundation
import WatchKit

class DailyInterfaceController: WKInterfaceController {
    
    // MARK: - Outlets
    @IBOutlet weak var picker: WKInterfacePicker!
    
    let defaults = UserDefaults.standard
    var pickerItems: [WKPickerItem] = []
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        for v in 1...20 {
        let aux = WKPickerItem()
        aux.title = String(v)
        pickerItems.append(aux)
        }
        picker.setItems(pickerItems)

        let index = defaults.integer(forKey: "DailyGoal") - 1
        self.picker.setSelectedItemIndex(index)
        
        super.willActivate()
    }
    
    @IBAction func pickerAction(_ value: Int) {
        let v = Int(self.pickerItems[value].title ?? "1")
        defaults.set(v, forKey: "DailyGoal")
    }
    
    
}
