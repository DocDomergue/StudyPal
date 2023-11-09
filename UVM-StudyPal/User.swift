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
    // TODO: Other info about user
    
    /*
     Create a new user
    TODO: Implement adding them to the database
     */
    init() {
        courses = []
        study = []
        custom = []
    }
    
    // TODO: Initialize from database
}
