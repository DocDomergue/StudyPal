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

    // Codable stuff
    init(name: String, subject: String, number: Int, instructor: String, building: String,
         room: String, startTime: DateComponents, endTime: DateComponents) {
        self.subject = subject
        self.number = number
        self.instructor = instructor
        self.building = building
        self.room = room
        super.init(name: name, startTime: startTime, endTime: endTime)
    }
        
    enum CodingKeys: String, CodingKey {
        case subject
        case number
        case instructor
        case building
        case room
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subject = try container.decode(String.self, forKey: .subject)
        self.number = try container.decode(Int.self, forKey: .number)
        self.instructor = try container.decode(String.self, forKey: .instructor)
        self.building = try container.decode(String.self, forKey: .building)
        self.room = try container.decode(String.self, forKey: .room)
        try super.init(from: decoder)
    }
        
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(subject, forKey: .subject)
        try container.encode(number, forKey: .number)
        try container.encode(instructor, forKey: .instructor)
        try container.encode(building, forKey: .building)
        try container.encode(room, forKey: .room)
        try super.encode(to: encoder)
    }

}
