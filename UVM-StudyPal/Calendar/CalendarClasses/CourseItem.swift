//
//  CourseItems.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

import SwiftUI

// Child class for relevant course info for the calendar.
// Its properties consist of the items we will be skimming from the UVM Schedule of Courses
class CourseItem: CalendarItem {
    
    var subject: String // i.e. CS
    var number: Int // i.e. 3010
    var instructor: String // i.e. Jason Hibbeler
    var building: String // i.e. Votey
    var room: String // i.e. 207
    
    // Constructor
    init(name: String, subject: String, number: String, instructor: String, building: String,
         room: String, startTime: DateComponents, endTime: DateComponents) {
        // TODO: Make the arg type for start and end String AFTER proper conversion is done in CalendarItems
        self.subject = subject
        self.number = Int(number).unsafelyUnwrapped
        self.instructor = instructor
        self.building = building
        self.room = room
        super.init(name: name, startTime: startTime, endTime: endTime)
    }
    
    // Getter for subject
    var getSubject: String {
        return subject
    }
    
    // Getter for number
    var getNumber: Int {
        return number
    }
    
    // Getter for instructor
    var getInstructor: String {
        return instructor
    }
    
    // Getter for building
    var getBuilding: String {
        return building
    }
    
    // Getter for room
    var getRoom: String {
        return room
    }
}
