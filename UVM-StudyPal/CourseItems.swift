//
//  CourseItems.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

// Child class for relevant course info for the calendar.
// Its properties consist of the items we will be skimming from the UVM Schedule of Courses
class CourseItems: CalendarItems {
    
    var subject: String // i.e. CS
    var number: Int // i.e. 3010
    var instructor: String // i.e. Jason Hibbeler
    var building: String // i.e. Votey
    var room: Int // i.e. 207
    
    // Constructor
    init(name: String, subject: String, number: String, instructor: String, building: String,
         room: String, startTime: String, endTime: String) {
        super.init(name: <#T##String#>, startTime: <#T##String#>, endTime: <#T##String#>)
        self.subject = subject
        self.number = Int(number).unsafelyUnwrapped
        self.instructor = instructor
        self.building = building
        self.room = Int(room).unsafelyUnwrapped
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
    var getRoom: Int {
        return room
    }
}
