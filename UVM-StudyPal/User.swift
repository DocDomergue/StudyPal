//
//  User.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import Foundation

class User: ObservableObject {
    @Published var courses: [CourseItems]
    @Published var study: [StudyItems]
    @Published var custom: [CustomItems]
    @Published var todo: [String] // Placeholder for now
    @Published var studyStat: Int
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
