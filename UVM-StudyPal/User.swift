//
//  User.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import Foundation

class User: ObservableObject {
    @Published var courses: [CourseItem] // TODO: Course Class
    @Published var study: [StudyItem]
    @Published var custom: [CustomItem]
    // TODO: Other info about user
    
    /*
     Create a new user
    TODO: Implement adding them to the database
     */
    init() {
        courses = []
        study = []
        custom = []
        
        let exampleCourseItem = CourseItem(
            name: "Mobile App Developement",
            subject: "CS",
            number: "3750",
            instructor: "Jason Hibbeler",
            building: "Lafayete",
            room: "L300",
            startTime: DateComponents(
                calendar: Calendar(identifier: .gregorian),
                year: 2023,
                month: 11,
                day: 28,
                hour: 10,
                minute: 0
            ),
            endTime: DateComponents(
                calendar: Calendar(identifier: .gregorian),
                year: 2023,
                month: 11,
                day: 28,
                hour: 10,
                minute: 10
            )
        )
        courses.append(exampleCourseItem)
        
        let exampleStudyItem = StudyItem(
            name: "Study reminder",
            course: exampleCourseItem,
            startTime: DateComponents(
                calendar: Calendar(identifier: .gregorian),
                year: 2023,
                month: 11,
                day: 29,
                hour: 19,
                minute: 35
            ),
            endTime: DateComponents(
                calendar: Calendar(identifier: .gregorian),
                year: 2023,
                month: 11,
                day: 29,
                hour: 21,
                minute: 5
            )
        )
        study.append(exampleStudyItem)
        
        let exampleCustomItem = CustomItem(
            name: "Reminder to do a thing",
            description: "This is a test",
            startTime: DateComponents(
                calendar: Calendar(identifier: .gregorian),
                year: 2023,
                month: 11,
                day: 28,
                hour: 19,
                minute: 35
            ),
            endTime: DateComponents(
                calendar: Calendar(identifier: .gregorian),
                year: 2023,
                month: 11,
                day: 28,
                hour: 21,
                minute: 5
            )
        )
        custom.append(exampleCustomItem)
    }
    
    // TODO: Initialize from database
    
    /**
     Given a timeframe "window," retrieves the course  items that reside within that window.
     - Parameters:
        - inWeek: The "window" week to select with
     */
    func selectCourses(inWeek week: Set<DateComponents>) -> [CourseItem] {
        // TODO: This will need to be changed to accomadate moving to a Course class
        
        // Filter out the dates that do not match a day in the selected week
        return courses.filter {
            if let dateFromComp = $0.startTime.date {
                // Check each day of the selected week for a matching day
                for weekDay in week {
                    if let weekDate = weekDay.date {
                        if Calendar.current.isDate(dateFromComp, inSameDayAs: weekDate) {
                            return true
                        }
                    }
                    else {
                        return false
                    }
                }
            }
            return false
        }
    }
    
    /**
     Given a timeframe "window," retrieves the study items that reside within that window.
     - Parameters:
        - inWeek: The "window" week to select with
     */
    func selectStudy(inWeek week: Set<DateComponents>) -> [StudyItem] {
        // Filter out the dates that do not match a day in the selected week
        return study.filter {
            if let dateFromComp = $0.startTime.date {
                // Check each day of the selected week for a matching day
                for weekDay in week {
                    if let weekDate = weekDay.date {
                        if Calendar.current.isDate(dateFromComp, inSameDayAs: weekDate) {
                            return true
                        }
                    }
                    else {
                        return false
                    }
                }
            }
            return false
        }
    }
    
    /**
     Given a timeframe "window," retrieves the custom items that reside within that window.
     - Parameters:
        - inWeek: The "window" week to select with
     */
    func selectCustom(inWeek week: Set<DateComponents>) -> [CustomItem] {
        // Filter out the dates that do not match a day in the selected week
        return custom.filter {
            if let dateFromComp = $0.startTime.date {
                // Check each day of the selected week for a matching day
                for weekDay in week {
                    if let weekDate = weekDay.date {
                        if Calendar.current.isDate(dateFromComp, inSameDayAs: weekDate) {
                            return true
                        }
                    }
                    else {
                        return false
                    }
                }
            }
            return false
        }
    }
}
