//
//  DayTimeGrid.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

struct DayTimeGrid: View {
    let daysOfWeek = ["Sunday", "Monday", "Tuesday",
                      "Wednesday", "Thursday", "Friday", "Saturday"]
    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section(header:
                        // Week day names
                    HStack(spacing: 75) {
                    ForEach(0..<7) { day in
                        Text(daysOfWeek[day])
                    }
                }
                .padding([.trailing, .leading], 100)
                .padding(.bottom, 20))
            {
                // Verticle times
                VStack(spacing: 30) {
                    ForEach(0..<25) { hour in
                        HourMark(hour: hour)
                    }
                }
            }
        }
    }
}

struct HourMark: View {
    var hour: Int
    var body: some View {
        HStack {
            Text(hourToTwelveHour(hour))
                .frame(width: 50)
            VStack {
                Divider()
            }
            Text(hourToTwelveHour(hour))
        }.padding()
    }
}

/**
 Convert an integer hour (0-24) into a twelve-hour time string (ex. "1 am")
 */
func hourToTwelveHour(_ hour: Int) -> String {
    if hour == 0 || hour == 24 {
        return "12 am"
    }
    else if hour == 12 {
        return "12 pm"
    }
    return "\(hour % 12) \(hour >= 12 ? "pm" : "am")"
}
