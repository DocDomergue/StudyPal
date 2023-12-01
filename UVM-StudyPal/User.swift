//
//  User.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import Foundation

class User: Codable, ObservableObject {
    @Published<[CourseItem]> var courses: [CourseItem] // TODO: Course Class
    @Published<[StudyItem]> var study: [StudyItem]
    @Published<[CustomItem]> var custom: [CustomItem]
    @Published<[String]> var todo: [String] // Placeholder for now
    @Published<Int> var studyStat: Int
    // TODO: Other info about user
    
    /*
     Create a new user
     TODO: Implement adding them to the database
     */
    init() {
        courses = []
        study = []
        custom = []
        todo = []
        studyStat = 0
        
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
    
    // Codable stuff
    enum CodingKeys: String, CodingKey {
        case courses
        case study
        case custom
        case todo
        case studyStat
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.courses = try container.decode([CourseItem].self, forKey: .courses)
        self.study = try container.decode([StudyItem].self, forKey: .study)
        self.custom = try container.decode([CustomItem].self, forKey: .custom)
        self.todo = try container.decode([String].self, forKey: .todo)
        self.studyStat = try container.decode(Int.self, forKey: .studyStat)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(courses, forKey: .courses)
        try container.encode(study, forKey: .study)
        try container.encode(custom, forKey: .custom)
        try container.encode(todo, forKey: .todo)
        try container.encode(studyStat, forKey: .studyStat)
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
    
    // TODO: Initialize from database + DB functions
    
    // Updates local structures with info from DB
    func pullFromDB() {
        
    }
    
    // Updates DB with info from local structures
    func pushToDB() {
        
    }
    
    // Callable function to increment the study minute counter when needed
    func iterateStudyStat() {
        studyStat+=1
    }
}
