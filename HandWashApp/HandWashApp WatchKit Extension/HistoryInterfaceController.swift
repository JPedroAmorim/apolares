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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var weekAndMonthHeader: WKInterfaceLabel!
    
    @IBOutlet weak var sundayRing: WKInterfaceGroup!
    @IBOutlet weak var sundayRingDayLabel: WKInterfaceLabel!
    
    @IBOutlet weak var mondayRing: WKInterfaceGroup!
    @IBOutlet weak var mondayRingDayLabel: WKInterfaceLabel!
    
    @IBOutlet weak var tuesdayRing: WKInterfaceGroup!
    @IBOutlet weak var tuesdayRingDayLabel: WKInterfaceLabel!
    
    @IBOutlet weak var wednesdayRing: WKInterfaceGroup!
    @IBOutlet weak var wednesdayRingDayLabel: WKInterfaceLabel!
    
    @IBOutlet weak var thursdayRing: WKInterfaceGroup!
    @IBOutlet weak var thursdayRingDayLabel: WKInterfaceLabel!
    
    @IBOutlet weak var fridayRing: WKInterfaceGroup!
    @IBOutlet weak var fridayRingDayLabel: WKInterfaceLabel!
    
    @IBOutlet weak var saturdayRing: WKInterfaceGroup!
    @IBOutlet weak var saturdayRingDayLabel: WKInterfaceLabel!
    
    @IBOutlet weak var previousButton: WKInterfaceButton!
    @IBOutlet weak var nextButton: WKInterfaceButton!
    
    
    let defaults = UserDefaults.standard
    
    // MARK: - Variables to be set when a controller is pushed into the stack
    
    /*
     
     I know it can be a bit confusing, but "NEXT" stands for the next value that will be pushed into the
     controller stack (on top of it, to be precise). But, in our case, a value will be pushed into the stack
     when the PREVIOUS BUTTON is tapped.
     
     */
    
    // This will be set when the previous button is tapped.
    var entryDatesForNextController: [Date]? = nil
    
    // It'll be used when the previous button is tapped.
    var nextControllerStartingDay: Date? = nil
    
    // This is to be set during the prepareForSegue method.
    var entryDatesForThisController: [Date]? = nil
    
    var entryDatesForPreviousController: [Date]? = nil
    
    var previousControllerStartingDay: Date? = nil
    
    // This will be set during the prepareForSegue method.
    var startingDay: Date?
    
    override func awake(withContext context: Any?) {
        
        super.awake(withContext: context)
        
        // See the previousPast method (at the bottom of this file) for further clarifying
        if let context = context as? (Date, [Date]) {
            self.startingDay = context.0
            self.entryDatesForThisController = context.1
        } else {
            print("ERROR IN GETTING TUPLE")
        }
        
        renderController()
    }
    
    
    private func renderController() {
        if let startingDay = self.startingDay, let entryDatesForThisController = self.entryDatesForThisController {
            
            setVariablesForNextController(nextControllerDates: entryDatesForThisController, startingDay: startingDay)
            
            setupButtonsEnableProperty(startingDay: startingDay)
            
            setupDisplay(dates: entryDatesForThisController, startingDay: startingDay)
        }
    }
    
    // MARK: -  Setup methods (In the order they appear in the awake method)
    
    private func setVariablesForNextController(nextControllerDates : [Date], startingDay: Date) {
        
        let entryDatesForNextController = nextControllerDates.filter({!(startingDay.isInSameWeek(as: $0))})
            .compactMap({$0}).sorted(by: {$0 > $1})
        
        /*
         
         If we get an empty array from the transformation above, then there shouldn't be
         any days to display in the next controller. So, we set the enable property of
         the previousButton as false.
         
         */
        
        if !entryDatesForNextController.isEmpty {
            
            self.entryDatesForNextController = entryDatesForNextController
            self.nextControllerStartingDay = entryDatesForNextController.first
            
        } else {
            
            self.entryDatesForNextController = entryDatesForNextController
            self.nextControllerStartingDay = nil
        }
    }
    
    private func setupButtonsEnableProperty(startingDay: Date) {
        
        let isToday: Bool = checkIfStartingDayIsToday(startingDay: startingDay)
        
        // If the startingDay is today, then there are no next entries to be displayed.
        
        if isToday {
            self.nextButton.setEnabled(false)
        } else {
            self.nextButton.setEnabled(true)
        }
        
        /*
         
         If there isn't any value stored in the self.nextControllerStartingDay property after the
         setVariablesForNextController method call, then there are no entries left and the user
         shouldn't be able to see previous entries.
         
         */
        
        if self.nextControllerStartingDay == nil {
            self.previousButton.setEnabled(false)
        } else {
            self.previousButton.setEnabled(true)
        }
    }
    
    
    private func setupDisplay(dates: [Date], startingDay: Date) {
        
        let daysThatWillBeDisplayed = getWeekdays(date: startingDay)
        
        for date in daysThatWillBeDisplayed {
            mapDatesIntoOutlets(date: date)
        }
        
        let monthsToBeDisplayed = Array(Set(daysThatWillBeDisplayed.map({$0.month})))
        
        if monthsToBeDisplayed.count == 1 {
            weekAndMonthHeader.setText(monthsToBeDisplayed[0])
        } else { // The case where a week is split between two months
            weekAndMonthHeader.setText(monthsToBeDisplayed[1] + "/" + monthsToBeDisplayed[0])
        }
        
    }
    
    // MARK: - setupDisplay Helper methods
    
    private func mapDatesIntoOutlets(date: Date) {
        
        let dateAsString = DateUtil.shared.formatter.string(from: date)
        
        switch getDayOfTheWeek(date: date) {
        case 1:
            setOutletTextAndAnimation(date: dateAsString, label: sundayRingDayLabel, group: sundayRing)
            
        case 2:
            setOutletTextAndAnimation(date: dateAsString, label: mondayRingDayLabel, group: mondayRing)
            
        case 3:
            setOutletTextAndAnimation(date: dateAsString, label: tuesdayRingDayLabel, group: tuesdayRing)
            
        case 4:
            setOutletTextAndAnimation(date: dateAsString, label: wednesdayRingDayLabel, group: wednesdayRing)
            
        case 5:
            setOutletTextAndAnimation(date: dateAsString, label: thursdayRingDayLabel, group: thursdayRing)
            
        case 6:
            setOutletTextAndAnimation(date: dateAsString, label: fridayRingDayLabel, group: fridayRing)
            
        case 7:
            setOutletTextAndAnimation(date: dateAsString, label: saturdayRingDayLabel, group: saturdayRing)
            
        default:
            print("ERROR DEFINING DAY OF THE WEEK")
        }
    }
    
    private func getDayOfTheWeek(date : Date) -> Int? {
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        
        return weekDay
    }
    
    private func setOutletTextAndAnimation(date: String, label: WKInterfaceLabel, group: WKInterfaceGroup) {
        
        if let dayFromDate = getDayOfDate(date: date) {
            label.setTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            label.setText(dayFromDate)
            if let dateAsDate = DateUtil.shared.formatter.date(from: date) {
                if checkIfStartingDayIsToday(startingDay: dateAsDate) {
                    label.setTextColor(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
                }
            }
            
        } else {
            label.setText("?")
        }
        
        let entriesDict = WashDAO.allWashesEntries()
        
        if let numberOfWashes = entriesDict[date] {
            startAnimationRing(numberOfWashes: numberOfWashes, groupToBeAnimated: group)
        } else {
            startAnimationRing(numberOfWashes: 0, groupToBeAnimated: group)
        }
        
    }
    
    private func getDayOfDate(date : String) -> String? {
        
        guard let date = DateUtil.shared.formatter.date(from: date) else { return nil }
        
        return date.day
    }
    
    private func startAnimationRing(numberOfWashes: Int, groupToBeAnimated: WKInterfaceGroup) {
        
        let dailyGoal = defaults.integer(forKey: "DailyGoal")
        
        var completionLength = numberOfWashes > dailyGoal ? 100 : numberOfWashes * (100/dailyGoal)
        
        if numberOfWashes == 0 {
            completionLength = 1
        }
        
        let duration = 1.0
        
        groupToBeAnimated.setBackgroundImageNamed("ring")
        groupToBeAnimated.startAnimatingWithImages(in: NSRange(location: 0, length: completionLength),
                                                   duration: duration,
                                                   repeatCount: 1)
    }
    
    func getWeekdays(date: Date) -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1 // Week start on Sunday
        let today = calendar.startOfDay(for: date)
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
    
    // MARK: setupButtonsEnableProperty Helper method
    
    private func checkIfStartingDayIsToday(startingDay: Date) -> Bool {
        
        let startingDayAsString = DateUtil.shared.formatter.string(from: startingDay)
        
        let todaysDateAsString = DateUtil.shared.formatter.string(from: Date())
        
        return startingDayAsString == todaysDateAsString
    }
    
    // MARK: - IBActions
    
    @IBAction func nextPressed() {
        
        if let previousControllerStartingDay = self.previousControllerStartingDay, let entryDatesForPreviousController =
            self.entryDatesForPreviousController {
            
            self.startingDay = previousControllerStartingDay
            self.entryDatesForThisController = entryDatesForPreviousController
            
            renderController()
        }
    }
    
    @IBAction func previousPressed() {
        
        if let nextControllerStartingDay = self.nextControllerStartingDay, let entryDatesForNextController =
            self.entryDatesForNextController, let startingDay = self.startingDay,
            let entryDateForThisController = self.entryDatesForThisController {
            
            self.previousControllerStartingDay = startingDay
            self.entryDatesForPreviousController = entryDateForThisController
            
            self.startingDay = nextControllerStartingDay
            self.entryDatesForThisController = entryDatesForNextController
            
            renderController()
        }
    }
}
