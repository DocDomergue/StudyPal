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
    }
    
    // TODO: Initialize from database
}
