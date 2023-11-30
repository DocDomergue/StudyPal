//
//  DayPicker.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/23/23.
//

import SwiftUI

// View structure that shows the days of the week for the user to select
struct DayPicker: View {
    @EnvironmentObject var manager: CalendarManager
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(manager.DAYS_OF_WEEK, id: \.self) { day in
                DayButton(day: day)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill()
                .foregroundColor(Color(hue: 0.13, saturation: 1.0, brightness: 0.878))
                .opacity(0.5)
        )

    }
}

struct DayButton: View {
    @EnvironmentObject var manager: CalendarManager
    var day: String
    
    var body: some View {
        if manager.dayOfWeek == manager.getDayOfWeekByName(day) {
            Text(day[day.startIndex...day.index(day.startIndex, offsetBy: 0)])
                .padding()
                .frame(width: 50)
                .foregroundColor(Color.black)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                    .fill()
                    .foregroundColor(Color.accentColor)
            )
            
        }
        else {
            Button {
                manager.setDayOfWeekByName(day)
            } label: {
                Text(day[day.startIndex...day.index(day.startIndex, offsetBy: 0)])
                    .foregroundColor(Color.black)
            }
            .padding()
            .frame(width: 50)
            
        }
    }
}

struct DayPicker_Previews: PreviewProvider {
    static var previews: some View {
        DayPicker()
            .environmentObject(CalendarManager())
    }
}
