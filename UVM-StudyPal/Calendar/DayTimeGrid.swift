//
//  DayTimeGrid.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

let timeTextHeight: CGFloat = 10

struct DayTimeGrid: View {
    @EnvironmentObject var manager: CalendarManager
    
    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section(header:
                VStack { // Bogus vstack to make header happy (conditional)
                    if (manager.isDayView) {
                        // Day of week chosen in the manager
                        Text(manager.DAYS_OF_WEEK[manager.dayOfWeek - 1])
                            .padding([.trailing, .leading], manager.SIDE_PADDING)
                            .padding(.bottom, 20)
                    }
                    else {
                        // Week day names
                        HStack(spacing: manager.getDayWidth() * 0.15) {
                            ForEach(0..<7) { day in
                                Text(manager.DAYS_OF_WEEK[day])
                                    .frame(width: manager.getDayWidth() * 0.85)
                            }
                        }
                        .padding([.trailing, .leading], manager.SIDE_PADDING)
                        .padding(.bottom, 20)
                    }
                }
            ) {
                // Verticle times
                VStack(spacing: manager.HOUR_HEIGHT - timeTextHeight) {
                    ForEach(0..<25) { hour in
                        HourMark(hour: hour)
                    }
                }
            }
        }
    }
}

struct HourMark: View {
    @EnvironmentObject var manager: CalendarManager
    var hour: Int
    var body: some View {
        HStack {
            Text(hourToTwelveHour(hour))
                .frame(width: 50)
            VStack {
                Divider()
            }
            if !manager.isDayView {
                Text(hourToTwelveHour(hour))
            }
        }
        .padding(.horizontal, 5)
        .frame(height: timeTextHeight)
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

struct DayTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DayTimeGrid()
            .environmentObject(CalendarManager())
    }
}
