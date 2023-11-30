//
//  CalendarItems.swift
//
//  CalendarItems.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

import SwiftUI

// This is written with the expectation that everything from the API will be recieved as strings and parsed in after the fact
// Parent class for everything displayed on the calendar.
// From the heighest view, these 3 bits of information will be all thats needed to create a tile
// Different more detail views will exist for each subtype of event
class CalendarItem {
    
    var name: String // Name displayed on tile
    var startTime: DateComponents // Start time
    var endTime: DateComponents // End time
    
    // TODO: Start and end times should be DateComponent. Convert in constructor
    
    // Constructor
    init(name: String, startTime: DateComponents, endTime: DateComponents) {
        self.name = name
        // TODO: Construct DateComponents from string
        self.startTime = startTime
        self.endTime = endTime
    }
    
    // Getter for name
    var getName: String {
        return name
    }
    
    // Getter for startTime
    var getStartTime: DateComponents {
        return startTime
    }
    
    // Getter for endTime
    var getEndTime: DateComponents {
        return endTime
    }
    
    /**
    Gets the length of this calendar item in minutes (smallest unit of measurement for an item).
     */
    func getMinutes() -> CGFloat {
        // Number of hours
        var totalHours = 0
        if let eHour = self.endTime.hour {
            if let sHour = self.startTime.hour {
                totalHours = eHour - sHour
            }
        }
        // Number of excess minutes
        var totalMin = 0
        if let eMin = self.endTime.minute {
            if let sMin = self.startTime.minute {
                totalMin = eMin - sMin
            }
        }
        // Calculate the minutes
        return CGFloat((totalHours * 60) + totalMin)
    }
    
    /**
     Identifies the day of the week that the item falls on. The day is defined and returned as an Integer (1-7) consistent with the
     representation of days in the CalendarManager (and Swift's Date system).
     If the item is between multiple days, the first first day is returned.
     TODO: Better handling for multiple days?
     */
    func getDayOfWeek() -> Int {
        // Ensure that the startTime has a calendar to convert with
        startTime.calendar = Calendar(identifier: .gregorian)
        // Convert the calendar to get the weekday (Int)
        if let dateFromComp = startTime.date {
            return Calendar.current.component(.weekday, from: dateFromComp)
        }
        return 1 // Should never get here
    }
}
