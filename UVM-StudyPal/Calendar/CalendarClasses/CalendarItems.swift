//
//  CalendarItems.swift
//
//  CalendarItems.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

// This is written with the expectation that everything from the API will be recieved as strings and parsed in after the fact
// Parent class for everything displayed on the calendar.
// From the heighest view, these 3 bits of information will be all thats needed to create a tile
// Different more detail views will exist for each subtype of event
class CalendarItems {
    
    var name: String // Name displayed on tile
    var startTime: String // Start time
    var endTime: String // End time
    
    // TODO: Start and end times should be DateComponent. Convert in constructor
    
    // Constructor
    init(name: String, startTime: String, endTime: String) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
    }
    
    // Getter for name
    var getName: String {
        return name
    }
    
    // Getter for startTime
    var getStartTime: String {
        return startTime
    }
    
    // Getter for endTime
    var getEndTime: String {
        return endTime
    }
}
