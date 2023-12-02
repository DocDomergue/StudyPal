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
    
    // DB functions
    
    func push(completion: @escaping (Bool, Error?) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(self)
            NetworkManager.shared.updateUserProfile(jsonData: jsonData, completion: completion)
        } catch {
            completion(false, error)
        }
    }
    

    struct EmptyProfile: Codable {
        var todo: [String]
        var study: [String]
        var custom: [String]
        var courses: [String]
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



