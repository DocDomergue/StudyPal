//
//  Blocks.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

// Structures used to create the course blocks
struct Blocks: View {
    @EnvironmentObject var manager: CalendarManager
    @EnvironmentObject var user: User
    
    var body: some View {
        // Delegates what blocks are shown based on the viewmodel
        // "visibleWeek" in the CalendarManager.
        
        /* TODO: Generate CourseItems from user's courses
                 Change courses list to Course array type in user.
                 Use that to generate CourseItems BASED ON CURRENT WEEK IN CALENDARMANAGER
         
                This should be a function in User that is used in selectItems
         */
        ForEach(user.selectCourses(inWeek: manager.visibleWeek)) { item in
            CourseBlock(item: item)
        }
        ForEach(user.selectStudy(inWeek: manager.visibleWeek)) { item in
            StudyBlock(item: item)
        }
        ForEach(user.selectCustom(inWeek: manager.visibleWeek)) { item in
            CustomBlock(item: item)
        }
    }
}
