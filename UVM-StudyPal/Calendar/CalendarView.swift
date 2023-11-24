//
//  CalendarView.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/23/23.
//



import SwiftUI

/*
 Things to do for a working/good looking calendar:
 
 Essential:
 - TODO: Placement of controls (day/week toggle, week picker, ect.)
 - TODO: Header showing week
 - TODO: DayPicker
 - TODO: Stop the overlap of things with days-of-week
 - TODO: Block stylization
 - TODO: Interaction with data (manager.visibleWeek / manager.dayOfWeek)
 
 Nice To Have:
 - TODO: Arrow controls (to not have to access sheet)
 */

struct CalendarView: View {
    @EnvironmentObject var manager: CalendarManager
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Toggle("Day", isOn: $manager.isDayView)
                WeekPicker()
                
            }
            .frame(maxHeight: 50)
            .padding()
            
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
