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
    
    // Codable stuff
    enum CodingKeys: String, CodingKey {
        case course
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.course = try container.decode(CourseItem.self, forKey: .course)
        try super.init(from: decoder)
    }
        
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(course, forKey: .course)
        try super.encode(to: encoder)
    }

}
