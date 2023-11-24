//
//  CalendarManager.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/22/23.
//

import SwiftUI

/**
 
 */
class CalendarManager: ObservableObject {
    // ViewModel: handles the content of the calendar
    // TODO: @Published var visibleWeek:
    @Published var isDayView: Bool = false
    @Published var dayOfWeek: Int = 1 // 1-7 (Days of week, used only when isDayView)
    
    // Week/Day defined Constants
    @Published var HOUR_HEIGHT: CGFloat = 50
    @Published var SIDE_PADDING: CGFloat = 100
    @Published var DAYS_OF_WEEK = ["Sunday", "Monday", "Tuesday",
                      "Wednesday", "Thursday", "Friday", "Saturday"]
    
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
