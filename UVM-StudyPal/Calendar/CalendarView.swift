//
//  CalendarView.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/23/23.
//



import SwiftUI

/*
 Things to do for a working/good looking calendar:
 
 - TODO: Block stylization
 - TODO: Interaction with data (manager.visibleWeek / manager.dayOfWeek)
 */

// View structure that puts all the individual calendar elements together
struct CalendarView: View {
    @EnvironmentObject var manager: CalendarManager
    
    var body: some View {
        VStack {
            Spacer()
            
            Picker("Calendar Style", selection: $manager.isDayView) {
                Text("Week").tag(false)
                Text("Day").tag(true)
            }
                .pickerStyle(.segmented)
            //Toggle("Day", isOn: $manager.isDayView)
            WeekPicker()
                .frame(maxHeight: 50)
                .padding(.vertical, 5)
            
            if manager.isDayView {
                DayView()
            }
            else {
                WeekView()
            }
            
            Spacer()
            
            if manager.isDayView {
                DayPicker()
            }
            
            Spacer()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(CalendarManager())
    }
}
