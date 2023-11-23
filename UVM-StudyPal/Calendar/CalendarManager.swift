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
    
}
