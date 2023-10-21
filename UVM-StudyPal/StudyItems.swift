//
//  StudyItems.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

// Child class for study blocks on the calendar.
// Holds a pointer to the course that the study period is for
class StudyItems: CalendarItems {
    
    var course: CourseItems // Course the studying is for
    
    // Constructor
    init(name: String, course: CourseItems, startTime: String, endTime: String) {
        super.init(name: <#T##String#>, startTime: <#T##String#>, endTime: <#T##String#>)
        self.course = course
    }
    
    // Getter for course
    var getRoom: CourseItems {
        return course
    }
}
