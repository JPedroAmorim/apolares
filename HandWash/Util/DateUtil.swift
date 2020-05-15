//
//  DateUtil.swift
//  HandWash WatchKit Extension
//
//  Created by João Pedro de Amorim on 15/05/20.
//  Copyright © 2020 AndrePapoti. All rights reserved.
//

import Foundation

class DateUtil {
    static let shared = DateUtil()
    
    private init () {
        self.formatter.dateFormat = "dd/MM/yyyy"
        self.formatter.timeStyle = .none
        self.formatter.dateStyle = .short
    }
    
    var formatter = DateFormatter()
    
}
