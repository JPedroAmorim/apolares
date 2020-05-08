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
    
    // MARK: - Lifecycle methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    
    override func willActivate() {
        super.willActivate()
        
        let numberOfWashesToday = WashDAO.numberOfWashesToday()
        
        self.labelFraction.setText("\(numberOfWashesToday)/5")
        
        self.startAnimationRing(numberOfWashesToday: numberOfWashesToday)
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
}
