//
//  HistoryInterfaceController.swift
//  HandWash WatchKit Extension
//
//  Created by João Pedro de Amorim on 15/05/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import WatchKit
import Foundation


class HistoryInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var historyTable: WKInterfaceTable!
    
    let washEntries = WashDAO.allWashesEntries()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        historyTable.setNumberOfRows(12, withRowType: "WashRow")
        
//        let sortedDatesStrings = orderWashEntriesDates(washEntries: washEntries)
//
//
//        for index in 0..<historyTable.numberOfRows {
//            guard let controller = historyTable.rowController(at: index) as? WashRowController else { continue }
//
//            let rowEntryDate = sortedDatesStrings[index]
//            let rowEntryNumberOfWashes = washEntries[rowEntryDate]
//
//            controller.rowEntry = (rowEntryDate, rowEntryNumberOfWashes ?? 0)
//        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    private func orderWashEntriesDates(washEntries: [String : Int]) -> [String] {
        let dictKeys = Array(washEntries.keys)
        
        let dates = dictKeys.compactMap { DateUtil.shared.formatter.date(from: $0) }
        
        let sortedDates = dates.sorted { $0 > $1 }
        
        let sortedDateStrings = sortedDates.compactMap { DateUtil.shared.formatter.string (from: $0) }
        
        return sortedDateStrings
    }
    
}
