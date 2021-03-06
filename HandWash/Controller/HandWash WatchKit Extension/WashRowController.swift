//
//  WashRowController.swift
//  HandWash WatchKit Extension
//
//  Created by João Pedro de Amorim on 14/05/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit

class WashRowController: NSObject {
    
    @IBOutlet weak var ringGroup: WKInterfaceGroup!
    @IBOutlet weak var dateGroup: WKInterfaceGroup!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    
    
    var rowEntry: (String, Int)? {
        didSet {
            guard let rowEntry = rowEntry else { return }
            
            self.dateLabel.setText(rowEntry.0)
            startAnimationRing(numberOfWashesToday: rowEntry.1)
        }
    }
    
    private func startAnimationRing(numberOfWashesToday: Int) {
        var completionLength = numberOfWashesToday > 5 ? 100 : numberOfWashesToday * 20
        
        if numberOfWashesToday == 0 {
            completionLength = 1
        }
        
        let duration = 1.0
        
        self.ringGroup.setBackgroundImageNamed("ring")
        self.ringGroup.startAnimatingWithImages(in: NSRange(location: 0, length: completionLength),
                                                duration: duration,
                                                repeatCount: 1)
    }
}
