//
//  DayTimeGrid.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

// Code used for determining locations/sizes and drawing the grids

let timeTextHeight: CGFloat = 10
let headerColor = Color(hue: 0.131, saturation: 0.982, brightness: 0.822).opacity(0.4)

struct DayTimeGrid: View {
    @EnvironmentObject var manager: CalendarManager
    
    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section(header:
                VStack { // Bogus vstack to make header happy (conditional)
                    if manager.isDayView {
                        // Day of week chosen in the manager
                        Text(getDayTitle(ofDay: manager.dayOfWeek - 1, inWeek: manager.visibleWeek))
                            .padding([.trailing, .leading], manager.SIDE_PADDING)
                            .padding(.vertical, 15)
                    }
                    else {
                        // Week day names
                        HStack(spacing: manager.getDayWidth() * 0.15) {
                            ForEach(0..<7) { day in
                                Text(getDayTitle(ofDay: day, inWeek: manager.visibleWeek))
                                    .frame(width: manager.getDayWidth() * 0.85)
                            }
                        }
                        .padding([.trailing, .leading], manager.SIDE_PADDING)
                        .padding(.vertical, 15)
                    }
                }
                .frame(minWidth: 500)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(headerColor)
                }
            ) {
                ZStack {
                    // Vertical day highlights
                    if !manager.isDayView {
                        DayHighlight()
                    }
                    // Horizontal times
                    VStack(spacing: manager.HOUR_HEIGHT - timeTextHeight) {
                        ForEach(0..<25) { hour in
                            HourMark(hour: hour)
                        }
                    }
                    // Show calendar blocks
                    Blocks()
                }
            }
        }
    }
    
    /**
     Create the header day titles  ex. Sat. 1
     */
    func getDayTitle(ofDay dayIndex: Int, inWeek week: Set<DateComponents>) -> String {
        // Get the abreviation of the day
        let dayName = manager.DAYS_OF_WEEK[dayIndex]
        let upToIndex = dayName.index(dayName.startIndex, offsetBy: 3)
        let abrvDay = dayName.prefix(upTo: upToIndex)
        // Search the week for the day with proper weekday
        var dateDay = 0
        for weekDay in week {
            if let dateFromComp = weekDay.date {
                let weekday = Calendar.current.component(.weekday, from: dateFromComp)
                if weekday == dayIndex + 1 {
                    if let day = weekDay.day {
                        dateDay = day
                    }
                }
            }
        }
        
        
        var title = ""
        title += abrvDay
        title += ". "
        title += "\(dateDay)"
        
        return title
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


struct DayHighlight: View {
    @EnvironmentObject var manager: CalendarManager
    
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { dayNum in
                    Rectangle()
                        .fill()
                        .frame(width: manager.getDayWidth())
                        .frame(maxHeight: .infinity)
                        .foregroundColor(Color.gray)
                        .opacity(dayNum % 2 == 0 ? 0 : 0.1)
            }
        }
    }
    
    func offsetHighlight(_ dayNum: Int) -> CGFloat {
        return CGFloat(35 + (Int(manager.getDayWidth()) * dayNum))
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
