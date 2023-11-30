//
//  StudyItems.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

import SwiftUI

// Child class for study blocks on the calendar.
// Holds a pointer to the course that the study period is for
class StudyItem: CalendarItem {
    
    // TODO: Course class
    var course: CourseItem // Course the studying is for
    
    // Constructor
    init(name: String, course: CourseItem, startTime: DateComponents, endTime: DateComponents) {
        // TODO: Make the arg type for start and end String AFTER proper conversion is done in CalendarItems
        self.course = course
        super.init(name: name, startTime: startTime, endTime: endTime)
    }
    
    // Getter for course
    var getRoom: CourseItem {
        return course
    }
}
