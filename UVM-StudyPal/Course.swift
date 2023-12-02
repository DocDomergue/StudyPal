//
//  Course.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 12/2/23.
//

import Foundation


// Model for course data
struct Course: Codable {
    let subj, course_number, title, section: String
    let instructor: String
    let start_time, end_time: String? // nullable fields
    let days, bldg, room, credits: String
    let xlistings, lec_lab, coll_code: String
    let max_enrollment, current_enrollment, comp_numb, id: Int
    let email: String
    
    /**
     Given a specified week, generate the course items that this course should display for that week
     */
    func generateCourseItems(_ week: Set<DateComponents>, _ dayCodes: [String]) -> [CourseItem] {
        // Convert the days to an array of days
        var dayArr = days.split(separator: " ")
        dayArr = dayArr.filter {$0 != ""}
        
        var courseItems: [CourseItem] = []
        
        for day in dayArr {
            // Use day to select the day of the week
            var dateOfDay: DateComponents = DateComponents() // Just for initilaization
            for date in week {
                if let dateFromComp = date.date {
                    let weekday = Calendar.current.component(.weekday, from: dateFromComp)
                    if let dayIndex = dayCodes.firstIndex(of: String(day)) {
                        if weekday == dayIndex + 1 {
                            dateOfDay = date
                        }
                    }
                }
            }
            
            // Convert the start time and end time into date components
            // To act as start and end of item
            if let sTime = start_time {
                let startTimeComp = sTime.split(separator: ":")
                if let eTime = end_time {
                    let endTimeComp = eTime.split(separator: ":")
                    
                    // Build the start time
                    var startTime = DateComponents(calendar: Calendar(identifier: .gregorian))
                    startTime.hour = (startTimeComp[0] as NSString).integerValue
                    startTime.minute = (startTimeComp[1] as NSString).integerValue
                    if let year = dateOfDay.year {
                        startTime.year = year
                    }
                    if let month = dateOfDay.month {
                        startTime.month = month
                    }
                    if let day = dateOfDay.day {
                        startTime.day = day
                    }
                    
                    // Build the end time
                    var endTime = DateComponents(calendar: Calendar(identifier: .gregorian))
                    endTime.hour = (endTimeComp[0] as NSString).integerValue
                    endTime.minute = (endTimeComp[1] as NSString).integerValue
                    if let year = dateOfDay.year {
                        endTime.year = year
                    }
                    if let month = dateOfDay.month {
                        endTime.month = month
                    }
                    if let day = dateOfDay.day {
                        endTime.day = day
                    }
                    
                    // Ensure that the courseitem is within the semester
                    if let date = startTime.date {
                        if date.isBetween(FALL_SEMESTER_START, and: FALL_SEMESTER_END) ||
                            date.isBetween(SPRING_SEMESTER_START, and: SPRING_SEMESTER_END) {
                            
                            // Build the course item and add it
                            courseItems.append(CourseItem(
                                name: title,
                                subject: subj,
                                number: course_number,
                                instructor: instructor,
                                building: bldg,
                                room: room,
                                startTime: startTime,
                                endTime: endTime
                            ))
                            
                        }
                    }
                }
            }
        }
        
        return courseItems
    }
}


// Extension for checking if a date is between two dates safely.
// Taken from here:
// https://stackoverflow.com/questions/32859569/check-if-date-falls-between-2-dates
extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}
