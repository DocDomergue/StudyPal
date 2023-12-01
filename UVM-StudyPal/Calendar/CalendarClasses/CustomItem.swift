//
//  CustomItems.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

import SwiftUI

// Child class for user created tiles on the calendar.
// Take a description, which the users will be able to read when they click on the tile
class CustomItem: CalendarItem {
    
    var description: String // User entered description
    
    // Constructor
    init(name: String, description: String, startTime: DateComponents, endTime: DateComponents) {
        // TODO: Make the arg type for start and end String AFTER proper conversion is done in CalendarItems
        self.description = description
        super.init(name: name, startTime: startTime, endTime: endTime)
    }
    
    // Getter for subject
    var getDescription: String {
        return description
    }
    
    // Codable stuff
    enum CodingKeys: String, CodingKey {
        case description
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decode(String.self, forKey: .description)
        try super.init(from: decoder)
    }
        
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try super.encode(to: encoder)
    }

}
