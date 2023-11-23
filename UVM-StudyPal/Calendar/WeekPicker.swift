//
//  WeekPicker.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

struct WeekPicker: View {
    @State private var showPicker = false
    @State var selectedDates: Set<DateComponents>
    @State var weekDescription: String
    
    init() {
        self.selectedDates = getCurrentWeek()
        self.weekDescription = describeWeek(getCurrentWeek())
        // TODO: ADJUST CALENDARMANAGER
    }
    
    var body: some View {
        Button(action: {showPicker = true}) {
            Text(weekDescription)
                // TODO: Better sizing
                .frame(width: 200, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill()
                        .foregroundColor(Color.gray)
                        .opacity(0.9)
                )
        }
        .sheet(isPresented: $showPicker) {
            WeekPickerSheet(selectedDates: $selectedDates, weekDescription: $weekDescription)
        }
    }
}

struct WeekPickerSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDates: Set<DateComponents>
    @Binding var weekDescription: String
    
    var body: some View {
        NavigationView() {
            // TODO: Provide a range to MultiDatePicker to limit to particular semester/year
            MultiDatePicker("Pick a Week", selection: $selectedDates)
                .onChange(of: selectedDates) { [selectedDates] newDates in
                    let dif = newDates.subtracting(selectedDates)
                    // If a new date was found, change the week
                    if let newDate = dif.first {
                        // Set selectedDates to the week of the selected date
                        self.selectedDates = getWeek(of: newDate)
                        // Change the description
                        weekDescription = describeWeek(self.selectedDates)
                        // TODO: ADJUST CALENDARMANAGER
                    }
                    // Else, don't let it change
                    else {
                        self.selectedDates = selectedDates
                    }
                }
                .navigationTitle(weekDescription)
                .toolbar(content: {
                    ToolbarItem {
                        Button {
                            dismiss()
                        } label: {
                            Label("Dismiss", systemImage: "xmark.circle.fill")
                        }
                    }
                })
        }
    }
}

/**
 Builds a week (Sun - Sat) from a DateComponents. A week is a set of DateComponents,
 each representing one day of the week.
 */
func getWeek(of date: DateComponents) -> Set<DateComponents> {
    // Get date in Date format to get weekday
    if let dateFromComp = date.date {
        let weekday = Calendar.current.component(.weekday, from: dateFromComp)
        // Use the weekday to build the week from the original DateComponent
        var week: Set<DateComponents> = []
        let start = -(weekday-1)
        for dayDif in start...start+6 {
            // Calculate the new date to add
            if let newDate = Calendar.current.date(byAdding: DateComponents(day: dayDif), to: dateFromComp) {
                // Convert it to DateComponents and add it
                let dateComponents = Calendar.current.dateComponents([.calendar, .era, .year, .month, .day], from: newDate)
                week.insert(dateComponents)
            }
        }
        
        return week
    }
    return []
}

/**
 Uses getWeek to get the current week.
 */
func getCurrentWeek() -> Set<DateComponents> {
    let today = Calendar.current.dateComponents([.calendar, .era, .year, .month, .day], from: Date())
    return getWeek(of: today)
}

/**
 Creates a string description of the week in the form (month/day - month/day year)
 */
func describeWeek(_ week: Set<DateComponents>) -> String {
    let weekDates = week.compactMap {
        if let date = $0.date {
            return date
        }
        else {
            return nil
        }
    }
    // Get the earliest and latest days, and create the string
    var description = ""
    if let earliest = weekDates.min() {
        let e = Calendar.current.dateComponents([.year, .month, .day], from: earliest)
        if let month = e.month {
            description += "\(month)"
        }
        description += "/"
        if let day = e.day {
            description += "\(day)"
        }
        description += "/"
        if let year = e.year {
            description += "\(year)"
        }
    }
    description += " - "
    if let latest = weekDates.max() {
        let l = Calendar.current.dateComponents([.year, .month, .day], from: latest)
        if let month = l.month {
            description += "\(month)"
        }
        description += "/"
        if let day = l.day {
            description += "\(day)"
        }
        description += "/"
        if let year = l.year {
            description += "\(year)"
        }
    }
    return description
    
}

struct WeekPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeekPicker()
    }
}

