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
        
        /* TODO: Pull from user instance BASED ON CURRENT WEEK IN CALENDARMANAGER
                 One block per day of each item.
                 Extract days from dates in other items.
         */
        /* TODO: Generate CourseItems from user's courses
                 Change courses list to Course array type in user.
                 Use that to generate CourseItems BASED ON CURRENT WEEK IN CALENDARMANAGER
         
         */
        
        let exampleCourseItem = CourseItem(
            name: "Mobile App Developement",
            subject: "CS",
            number: "3750",
            instructor: "Jason Hibbeler",
            building: "Lafayete",
            room: "L300",
            startTime: DateComponents(
                year: 2023,
                month: 11,
                day: 28,
                hour: 10,
                minute: 0
            ),
            endTime: DateComponents(
                year: 2023,
                month: 11,
                day: 28,
                hour: 10,
                minute: 10
            )
        )
        
        let exampleStudyItem = StudyItem(
            name: "Study reminder",
            course: exampleCourseItem,
            startTime: DateComponents(
                year: 2023,
                month: 11,
                day: 29,
                hour: 19,
                minute: 35
            ),
            endTime: DateComponents(
                year: 2023,
                month: 11,
                day: 29,
                hour: 21,
                minute: 5
            )
        )
        
        let exampleCustomItem = CustomItem(
            name: "Reminder to do a thing",
            description: "This is a test",
            startTime: DateComponents(
                year: 2023,
                month: 11,
                day: 28,
                hour: 19,
                minute: 35
            ),
            endTime: DateComponents(
                year: 2023,
                month: 11,
                day: 28,
                hour: 21,
                minute: 5
            )
        )
        
        // Example blocks
        CourseBlock(item: exampleCourseItem)
        StudyBlock(item: exampleStudyItem)
        CustomBlock(item: exampleCustomItem)
        /*CalendarBlock(desc: "Test",
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
                      color: Color.blue)*/
    }
}
