//
//  CalendarManager.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/22/23.
//

import SwiftUI

// Code and class controlling how the program knows what date and week is in view on the screen for the calendar page
class CalendarManager: ObservableObject {
    @Published var visibleWeek: Set<DateComponents> = [] // ViewModel: handles the content of the calendar
    @Published var dayOfWeek: Int = 1 // 1-7 (Days of week, used only when isDayView)
    @Published var isDayView: Bool = false
    
    // Week/Day defined Constants
    @Published var HOUR_HEIGHT: CGFloat = 50
    @Published var HOUR_TEXT_WIDTH: CGFloat = 50
    @Published var HOUR_TEXT_HEIGHT: CGFloat = 10
    @Published var HOUR_MARK_PADDING: CGFloat = 5
    @Published var SIDE_PADDING: CGFloat = 100
    @Published var DAYS_OF_WEEK = ["Sunday", "Monday", "Tuesday",
                      "Wednesday", "Thursday", "Friday", "Saturday"]
    // TODO: What's the true code for Sunday?
    @Published var DAY_CODES = ["N", "M", "T", "W", "R", "F", "S"]
    @Published var BLOCK_MIN_MINUTES = 20
    @Published var BLOCK_FONT_SIZE: CGFloat = 12
    @Published var BLOCK_COLOR_COURSE = Color.blue
    @Published var BLOCK_COLOR_COURSE_LIGHT = Color(red: 0.61, green: 0.76, blue: 1.0)
    @Published var BLOCK_COLOR_STUDY = Color.yellow
    @Published var BLOCK_COLOR_STUDY_LIGHT = Color(red: 1.0, green: 1.0, blue: 0.61)
    @Published var BLOCK_COLOR_CUSTOM = Color.green
    @Published var BLOCK_COLOR_CUSTOM_LIGHT = Color(red: 0.61, green: 1.0, blue: 0.64)
    
    init() {
        self.setToCurrentWeek()
    }
    
    func setToWeekView() {
        isDayView = false
    }
    
    func setToDayView() {
        isDayView = true
    }
    
    func getDayWidth() -> CGFloat {
        if isDayView {
            return 300
        }
        else {
            return 115
        }
    }
    
    func getPositionOffset() -> CGFloat {
        var offset = HOUR_TEXT_WIDTH + getDayWidth()/2 + HOUR_MARK_PADDING
        if isDayView {
            offset += 12
        }
        else {
            // Adjusting for header titles not reaching all the way over
            offset += SIDE_PADDING/2 - 13
        }
        return offset
    }
    
    /* ******************************** */
    /** --------------- Week Controls ---------------------- */
    /* ******************************** */
    
    func getWeek(of date: DateComponents) -> Set<DateComponents> {
        // Get date in Date format to get weekday
        if let dateFromComp = date.date {
            let weekday = Calendar.current.component(.weekday, from: dateFromComp)
            // Use the weekday to build the week from the original DateComponent
            var week: Set<DateComponents> = []
            let start = -(weekday-1)
            for dayDif in start...start+6 {
                // Calculate the new date to add
                if let newDate = Calendar.current.date(byAdding: DateComponents(day: dayDif), to: dateFromComp) {
                    // Convert it to DateComponents and add it
                    let dateComponents = Calendar.current.dateComponents([.calendar, .era, .year, .month, .day], from: newDate)
                    week.insert(dateComponents)
                }
            }
            return week
        }
        return []
    }
    
    func setWeek(_ week: Set<DateComponents>) {
        self.visibleWeek = week
    }
    
    func setToCurrentWeek() {
        let today = Calendar.current.dateComponents([.calendar, .era, .year, .month, .day], from: Date())
        self.setWeek(self.getWeek(of: today))
    }
    
    func weekDecrease() {
        // Decrease each day by a week
        let lastWeek: Set<DateComponents> = Set(visibleWeek.map {
            if let date = $0.date {
                // Decrease the date by a week
                if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: date) {
                    return Calendar.current.dateComponents([.calendar, .era, .year, .month, .day], from: newDate)
                }
            }
            print("Something went wrong in weekDecrease")
            return DateComponents()
        })
        // Set the new week
        visibleWeek = lastWeek
    }
    
    func weekIncrease() {
        // Decrease each day by a week
        let lastWeek: Set<DateComponents> = Set(visibleWeek.map {
            if let date = $0.date {
                // Decrease the date by a week
                if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: date) {
                    return Calendar.current.dateComponents([.calendar, .era, .year, .month, .day], from: newDate)
                }
            }
            print("Something went wrong in weekIncrease")
            return DateComponents()
        })
        // Set the new week
        visibleWeek = lastWeek
    }
    
    func describeWeek() -> String {
        let weekDates = self.visibleWeek.compactMap {
            if let date = $0.date {
                return date
            }
            else {
                return nil
            }
        }
        // Get the earliest and latest days, and create the string
        var description = ""
        if let earliest = weekDates.min() {
            let e = Calendar.current.dateComponents([.year, .month, .day], from: earliest)
            if let month = e.month {
                description += "\(month)"
            }
            description += "/"
            if let day = e.day {
                description += "\(day)"
            }
            description += "/"
            if let year = e.year {
                description += "\(year)"
            }
        }
        description += " - "
        if let latest = weekDates.max() {
            let l = Calendar.current.dateComponents([.year, .month, .day], from: latest)
            if let month = l.month {
                description += "\(month)"
            }
            description += "/"
            if let day = l.day {
                description += "\(day)"
            }
            description += "/"
            if let year = l.year {
                description += "\(year)"
            }
        }
        return description
    }
    
    /* ******************************** */
    /** ------------ Day of Week Controls ---------------- */
    /* ******************************** */

    
    func setDayOfWeek(_ day: Int) {
        guard day >= 1 && day <= 7 else {
            dayOfWeek = 1
            return
        }
        dayOfWeek = day
    }
    
    func getDayOfWeekByName(_ day: String) -> Int {
        if let idx = DAYS_OF_WEEK.firstIndex(of: day) {
            return idx + 1
        }
        // Hopefully should never reach here
        return 1
    }
    
    func setDayOfWeekByName(_ day: String) {
        guard DAYS_OF_WEEK.contains(day) else {
            dayOfWeek = 1
            return
        }
        if let idx = DAYS_OF_WEEK.firstIndex(of: day) {
            dayOfWeek = idx + 1
        }
    }
    
}
