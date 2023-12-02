//
//  User.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import Foundation

struct TaskItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var isCompleted: Bool = false
}

class User: Codable, ObservableObject {
    @Published<[Course]> var courses: [Course]
    @Published<[StudyItem]> var study: [StudyItem]
    @Published<[CustomItem]> var custom: [CustomItem]
    @Published<[TaskItem]> var todo: [TaskItem] // Placeholder for now
    @Published<Int> var studyStat: Int
    // TODO: Other info about user
    
    // Create a new user
    init() {
        courses = []
        study = []
        custom = []
        todo = []
        studyStat = 7
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
        self.courses = try container.decode([Course].self, forKey: .courses)
        self.study = try container.decode([StudyItem].self, forKey: .study)
        self.custom = try container.decode([CustomItem].self, forKey: .custom)
        self.todo = try container.decode([TaskItem].self, forKey: .todo)
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
    func selectCourses(inWeek week: Set<DateComponents>, _ dayCodes: [String]) -> [CourseItem] {
        var courseItems: [CourseItem] = []
        for course in courses {
            let items = course.generateCourseItems(week, dayCodes)
            courseItems += items
        }
        courseItems.append(CourseItem(
            name: "Test",
            subject: "Test",
            number: "4444",
            instructor: "Test",
            building: "Test",
            room: "32",
            startTime: DateComponents(
                calendar: Calendar(identifier: .gregorian),
                year: 2023,
                month: 12,
                day: 1,
                hour: 23,
                minute: 00
            ),
            endTime: DateComponents(
                calendar: Calendar(identifier: .gregorian),
                year: 2023,
                month: 12,
                day: 2,
                hour: 01,
                minute: 00
            )
        ))
        return courseItems
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
    
    // DB functions
    
    func push(completion: @escaping (Bool, Error?) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(self)
            NetworkManager.shared.updateUserProfile(jsonData: jsonData, completion: completion)
            
            print("pushing\n")
        } catch {
            completion(false, error)
        }
    }
    

    struct EmptyProfile: Codable {
        var todo: [TaskItem]
        var study: [StudyItem]
        var custom: [CustomItem]
        var courses: [Course]
        var studyStat: Int
    }

    let emptyProfile = EmptyProfile(
        todo: [],
        study: [],
        custom: [],
        courses: [],
        studyStat: 0
    )
    
    
    func clearData(completion: @escaping (Bool, Error?) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(emptyProfile)
            NetworkManager.shared.updateUserProfile(jsonData: jsonData, completion: completion)
        } catch {
            completion(false, error)
        }
    }
    
    func pullUserProfile() {
        NetworkManager.shared.fetchUserProfile { result in
            switch result {
            case .success(let data):
                
                let decoder = JSONDecoder()
                do {
                    // Decode the data into a User object
                    let tempUser = try decoder.decode(User.self, from: data)
                    
                    // Update the properties of the current User object with the decoded data
                    self.courses = tempUser.courses
                    self.study = tempUser.study
                    self.custom = tempUser.custom
                    self.todo = tempUser.todo
                    self.studyStat = tempUser.studyStat
                    
                    print("pulling\n")
                    print(tempUser.courses)
                    print(tempUser.study)
                    print(tempUser.custom)
                    print(tempUser.todo)
                    print(tempUser.studyStat)
                    
                } catch {
                    print("Error decoding user profile: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error fetching user profile: \(error.localizedDescription)")
            }
        }
    }

    
    // Callable function to increment the study minute counter when needed
    func iterateStudyStat() {
        studyStat+=1
    }
}



