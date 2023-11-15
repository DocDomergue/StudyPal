//
//  CustomItems.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

// Child class for user created tiles on the calendar.
// Take a description, which the users will be able to read when they click on the tile
class CustomItems: CalendarItems {
    
    var description: String // User entered description
    
    // Constructor
    init(name: String, description: String, startTime: String, endTime: String) {
        self.description = description
        super.init(name: name, startTime: startTime, endTime: endTime)
    }
    
    // Getter for subject
    var getDescription: String {
        return description
    }
}
