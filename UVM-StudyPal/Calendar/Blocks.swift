//
//  Blocks.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

struct Blocks: View {
    var body: some View {
        // Delegates what blocks are shown based on the viewmodel
        // "visibleWeek" in the WVManager.
        
        /* TODO: Pull from user instance BASED ON CURRENT WEEK IN WVMANAGER
                 One block per day of each item.
                 Courses should have days already.
                 Extract days from dates in other items.
         */
        
        // Example blocks
        CalendarBlock(desc: "Test",
                      day: "W",
                      startTime: DateComponents(hour: 14, minute: 0),
                      endTime: DateComponents(hour: 15, minute: 30),
                      color: Color.blue)
        CalendarBlock(desc: "Test",
                      day: "R",
                      startTime: DateComponents(hour: 13, minute: 40),
                      endTime: DateComponents(hour: 15, minute: 28),
                      color: Color.blue)
        CalendarBlock(desc: "Test",
                      day: "F",
                      startTime: DateComponents(hour: 15, minute: 15),
                      endTime: DateComponents(hour: 17, minute: 0),
                      color: Color.blue)
    }
}
